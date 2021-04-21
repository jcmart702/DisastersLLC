<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="input">
    <xsl:param name="tag" select="'input'" />
    <xsl:param name="type" select="'text'" />
    <xsl:param name="name" select="''" />
    <xsl:param name="value" select="''" />
    <xsl:param name="placeholder" />
    <xsl:param name="required" select="false()" />
    <xsl:param name="options" />
    <xsl:param name="class" select="'form-control'" />
    <xsl:param name="id" />

    <xsl:element name="{$tag}">
      <xsl:if test="$type != 'textarea' and $type != 'select' and $type != 'honeypot'">
        <!-- input types. -->
        <xsl:attribute name="type">
          <xsl:value-of select="normalize-space($type)" />
        </xsl:attribute>
      </xsl:if>

      <xsl:attribute name="name">
        <xsl:value-of select="normalize-space($name)" />
      </xsl:attribute>

      <xsl:if test="$required">
        <xsl:attribute name="required">required</xsl:attribute>
      </xsl:if>

      <xsl:if test="normalize-space($value) != ''">
        <xsl:attribute name="value">
          <xsl:value-of select="normalize-space($value)" />
        </xsl:attribute>
      </xsl:if>

      <xsl:if test="normalize-space($placeholder) != ''">
        <xsl:attribute name="placeholder">
          <xsl:value-of select="normalize-space($placeholder)" />
        </xsl:attribute>
      </xsl:if>

      <xsl:if test="$type = 'textarea'">
        <xsl:attribute name="rows">5</xsl:attribute>
      </xsl:if>

      <xsl:if test="$class != ''">
        <xsl:attribute name="class">
          <xsl:value-of select="$class" />
        </xsl:attribute>
      </xsl:if>

      <xsl:if test="$id != ''">
        <xsl:attribute name="id">
          <xsl:value-of select="$id" />
        </xsl:attribute>
      </xsl:if>

      <xsl:if test="$options != ''">
        <xsl:if test="$type = 'select'">
          <xsl:call-template name="tokenize">
            <xsl:with-param name="text" select="$options" />
            <xsl:with-param name="delimiter" select="';'" />
            <xsl:with-param name="separator" select="''" />
            <xsl:with-param name="wrapper"><xsl:text disable-output-escaping="yes"><![CDATA[
              <option value="$token">$token</option>
            ]]></xsl:text></xsl:with-param>
            <xsl:with-param name="empty"><xsl:text disable-output-escaping="yes"><![CDATA[
              <option disabled selected>Select one</option>
            ]]></xsl:text></xsl:with-param>
          </xsl:call-template>
        </xsl:if>
      </xsl:if>
    </xsl:element>
  </xsl:template>

  <xsl:template match="field" mode="thumbnail" name="thumbnail">
    <xsl:param name="url" select="." />
    <xsl:param name="width" />
    <xsl:param name="height" />
    <xsl:param name="prefix" select="'/content/thumbs'" />
    <xsl:param name="suffix" />

    <xsl:variable name="folder">
      <xsl:call-template name="substring-before-last">
        <xsl:with-param name="value" select="$url"/>
        <xsl:with-param name="separator" select="'/'"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="file" select="substring-after($url, concat($folder, '/'))" />

    <!-- Output: {$prefix}{$folder}/w{$width}/h{$height}/{$file}{$suffix} -->
    <xsl:value-of select="$prefix" />
    <xsl:value-of select="$folder" />
    <xsl:if test="$width">/w<xsl:value-of select="$width" /></xsl:if>
    <xsl:if test="$height">/h<xsl:value-of select="$height" /></xsl:if>
    <xsl:value-of select="concat('/', $file)" />
    <xsl:if test="$suffix">
      <xsl:value-of select="$suffix" />
    </xsl:if>
  </xsl:template>

  <xsl:template match="field" mode="srcset" name="srcset">
    <!-- /content/inline-images/filename.ext -->
    <xsl:param name="src" select="." />
    <!-- w640/h360 640w, w960 768w -->
    <xsl:param name="set" />
    <xsl:param name="prefix" select="'/content/thumbs'" />

    <xsl:param name="folder">
      <xsl:call-template name="substring-before-last">
        <xsl:with-param name="value" select="$src"/>
        <xsl:with-param name="separator" select="'/'"/>
      </xsl:call-template>
    </xsl:param>
    <xsl:param name="file" select="substring-after($src, concat($folder, '/'))" />

    <xsl:choose>
      <xsl:when test="contains($set, ',')">
        <xsl:call-template name="srcset">
          <xsl:with-param name="src" select="$src" />
          <xsl:with-param name="set" select="normalize-space(substring-before($set, ','))" />
          <xsl:with-param name="folder" select="$folder" />
          <xsl:with-param name="file" select="$file" />
        </xsl:call-template>

        <xsl:text>, </xsl:text>

        <xsl:call-template name="srcset">
          <xsl:with-param name="src" select="$src" />
          <xsl:with-param name="set" select="normalize-space(substring-after($set, ','))" />
          <xsl:with-param name="folder" select="$folder" />
          <xsl:with-param name="file" select="$file" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="size">
          <xsl:choose>
            <xsl:when test="normalize-space(substring-after($set, ' ')) != ''">
              <xsl:value-of select="normalize-space(substring-after($set, ' '))"></xsl:value-of>
            </xsl:when>
            <xsl:otherwise>
              <!-- Dimension not set, only the size. -->
              <xsl:value-of select="$set" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="dimension" select="normalize-space(substring-before($set, $size))" />

        <xsl:if test="$dimension != ''">
          <!-- When dimension is not set, we want to use original image. -->
          <xsl:value-of select="$prefix" />
        </xsl:if>
        <xsl:value-of select="$folder" />
        <xsl:value-of select="$dimension" />
        <xsl:value-of select="concat('/', $file)" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="$size" />
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template name="substring-before-last">
    <xsl:param name="value" select="''" />
    <xsl:param name="separator" select="'/'" />

    <xsl:if test="$value != '' and $separator != ''">
      <xsl:variable name="head" select="substring-before($value, $separator)" />
      <xsl:variable name="tail" select="substring-after($value, $separator)" />
      <xsl:value-of select="$head" />
      <xsl:if test="contains($tail, $separator)">
        <xsl:value-of select="$separator" />
        <xsl:call-template name="substring-before-last">
          <xsl:with-param name="value" select="$tail" />
          <xsl:with-param name="separator" select="$separator" />
        </xsl:call-template>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template name="substring-after-last">
    <xsl:param name="value" />
    <xsl:param name="separator" select="'.'" />

    <xsl:choose>
      <xsl:when test="contains($value, $separator)">
        <xsl:call-template name="substring-after-last">
          <xsl:with-param name="value" select="substring-after($value, $separator)" />
          <xsl:with-param name="separator" select="$separator" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$value" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="text()" mode="tokenize" name="tokenize">
    <xsl:param name="text" select="." />
    <!-- The character dividing the tokens. -->
    <xsl:param name="delimiter" select="','" />
    <xsl:param name="prefix" />
    <!-- Words to be placed between tokens. -->
    <xsl:param name="separator" select="$delimiter" />
    <xsl:param name="wrapper" />
    <xsl:param name="empty" />

    <xsl:choose>
      <xsl:when test="contains($text, $delimiter)">
        <xsl:call-template name="tokenize">
          <xsl:with-param name="text" select="normalize-space(substring-before($text, $delimiter))" />
          <xsl:with-param name="delimiter" select="$delimiter" />
          <xsl:with-param name="prefix" select="$prefix" />
          <xsl:with-param name="separator" select="$separator" />
          <xsl:with-param name="wrapper" select="$wrapper" />
          <xsl:with-param name="empty" select="$empty" />
        </xsl:call-template>

        <xsl:value-of select="$separator" />

        <xsl:call-template name="tokenize">
          <xsl:with-param name="text" select="normalize-space(substring-after($text, $delimiter))" />
          <xsl:with-param name="delimiter" select="$delimiter" />
          <xsl:with-param name="prefix" select="$prefix" />
          <xsl:with-param name="separator" select="$separator" />
          <xsl:with-param name="wrapper" select="$wrapper" />
          <xsl:with-param name="empty" select="$empty" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$prefix" />
        <xsl:choose>
          <xsl:when test="normalize-space($text) = ''">
            <xsl:value-of select="$empty" disable-output-escaping="yes" />
          </xsl:when>
          <xsl:when test="$wrapper != ''">
            <xsl:call-template name="sam-replace-string">
              <xsl:with-param name="text" select="$wrapper" />
              <xsl:with-param name="replace" select="'$token'" />
              <xsl:with-param name="with" select="normalize-space($text)" />
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="normalize-space($text)" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>

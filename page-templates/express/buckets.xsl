<?xml version="1.0" encoding="UTF-8"?>
<!--
  Defines template rules that deal with various buckets.

  Usually, we don't need to override "chunk-grouper" template, as it
  groups chunks by entity type. But because this template rule has a
  `name`, we can always match the specific buckets, and `call-template`
  the "chunk-grouper" to group the chunks.
-->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="chunk" mode="bucket" name="chunk-grouper">
    <xsl:param name="siblings" select="." />
    <xsl:apply-templates select="
    .|$siblings[
      not(
        chunkData/@type = preceding-sibling::chunk[1]/chunkData/@type
        or (chunkData = false() and preceding-sibling::chunk[1]/chunkData = false())
      )
    ]" mode="chunk-grouping">
      <xsl:with-param name="style_formats" select="'.style-formats'" />
      <xsl:with-param name="siblings" select="$siblings"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="chunk" mode="chunk-grouping">
    <xsl:param name="siblings" select="." />
    <xsl:param name="element" select="''" />
    <xsl:param name="class" select="''" />
    <xsl:param name="mode" select="'chunk'" />
    <xsl:variable name="following-siblings-in-this-bucket" select="./following-sibling::chunk[count(.|$siblings) = count($siblings)]"/>
    <xsl:variable name="compare-value" select="chunkData/@type" />
    <xsl:variable name="next-groups" select="
    $following-siblings-in-this-bucket[
      not(
        chunkData/@type = $compare-value
        or (chunkData = false() and $compare-value = false())
      )
    ]" />
    <xsl:variable name="ns2" select="$next-groups[1]/preceding-sibling::chunk" />
    <!-- Kayessian XPath 1.0 formula for node-set intersection: $ns1[count(.|$ns2) = count($ns2)] -->
    <xsl:variable name="chunks-in-this-group" select=".|$following-siblings-in-this-bucket[
      count($next-groups) = 0 or (count(.|$ns2) = count($ns2))
    ]" />
    <xsl:choose>
      <xsl:when test="$element">
        <xsl:element name="{$element}">
          <xsl:if test="$class">
            <xsl:attribute name="class">
              <xsl:value-of select="$class"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:apply-templates select="$chunks-in-this-group" mode="chunk">
            <xsl:sort select="@sequence" order="ascending" data-type="number"/>
            <xsl:with-param name="style_formats" select="'.style-formats'" />
            <xsl:with-param name="siblings" select="$chunks-in-this-group"/>
          </xsl:apply-templates>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="$chunks-in-this-group" mode="chunk">
          <xsl:sort select="@sequence" order="ascending" data-type="number"/>
          <xsl:with-param name="style_formats" select="'.style-formats'" />
          <xsl:with-param name="siblings" select="$chunks-in-this-group"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Fallback for geric chunks in a bucket -->
  <xsl:template match="chunk[meta[@name = 'Content-Group']]" mode="chunk">
    <xsl:param name="siblings" />
    <xsl:variable name="bucket" select="./meta[@name = 'Content-Group']/value" />

    <xsl:if test="position() = 1">
      <section class="{translate($bucket, $uppercase, $lowercase)} padded">
        <div class="container w-container">
          <!-- <xsl:for-each select="$siblings">
            <xsl:switch>
              <xsl:when test="./">
                <xsl:apply-templates select="$siblings" mode="entity" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates select="$siblings" />
              </xsl:otherwise>
            </xsl:switch>
          </xsl:for-each> -->
          <xsl:apply-templates select="$siblings">
            <xsl:with-param name="style_formats" select="'.style-formats'" />
          </xsl:apply-templates>
        </div>
      </section>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
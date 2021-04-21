<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:key name="entity-field" match="chunkData/field" use="@name" />

  <xsl:template match="chunk[chunkData[@type = 'Form']]" mode="entity">
    <xsl:param name="class" />

    <xsl:variable name="fields" select="./chunkData/field" />
    <xsl:variable name="method" select="normalize-space($fields[@name = 'method-attribute'])" />

    <form>
      <xsl:if test="$method != ''">
        <xsl:attribute name="method">
          <xsl:choose>
            <xsl:when test="contains($method, 'Ajax')">
              <xsl:value-of select="substring-after($method, 'Ajax ')" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$method" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="$fields[@name = 'action-attribute'] != ''">
        <xsl:attribute name="action">
          <xsl:value-of select="normalize-space($fields[@name = 'action-attribute'])" />
        </xsl:attribute>
      </xsl:if>
      <xsl:attribute name="class">
        <xsl:if test="$class != ''">
          <xsl:value-of select="$class" />
        </xsl:if>
        <xsl:if test="contains($method, 'Ajax')">
          <xsl:text> ajax</xsl:text>
        </xsl:if>
      </xsl:attribute>

      <xsl:if test="count($fields[contains(., 'type:file')]) &gt; 0">
        <xsl:attribute name="enctype">multipart/form-data</xsl:attribute>
      </xsl:if>

      <div class="grid justify-start contact-form">
        <!-- <xsl:for-each select="$fields[generate-id() = generate-id(key('entity-field', @name)[1]) and contains(., 'index:')]"> -->
        <xsl:for-each select="$fields[contains(., 'index:')]">
          <xsl:sort
            select="substring-before(substring-after(., 'index:'), '|')"
            order="ascending" data-type="number" />

          <xsl:variable name="type" select="substring-before(substring-after(concat(., '|'), 'type:'), '|')" />
          <xsl:variable name="tag">
            <xsl:choose>
              <xsl:when test="$type = 'textarea' or $type = 'select'">
                <xsl:value-of select="$type"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>input</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="name" select="substring-before(substring-after(., 'name:'), '|')" />
          <xsl:variable name="options" select="substring-before(substring-after(concat(., '|'), 'options:'), '|')" />
          <xsl:variable name="label" select="substring-before(substring-after(., 'label:'), '|')" />
          <xsl:variable name="required" select="contains(., 'required:1')" />

          <div>
            <xsl:attribute name="class">
              <xsl:choose>
                <xsl:when test="$type = 'textarea' or (($type = 'checkbox' or $type = 'radio') and $options != '')">
                  <xsl:text>col-sm-12 col-md-10 </xsl:text>
                </xsl:when>
                <xsl:when test="$type = 'hidden' or $type = 'honeypot'"></xsl:when>
                <xsl:otherwise>col-sm-6 col-md-5 col-bleed-y </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>

            <xsl:choose>
              <xsl:when test="($type = 'checkbox' or $type = 'radio') and $options != ''">
                <!-- Checkbox or radio group -->
                <div class="form-group" role="group" aria-labelledby="{$name}__label">
                  <div class="grid">
                    <label id="{$name}__label" class="col-sm-5"><xsl:value-of select="$label" /></label>

                    <div class="col-sm-7">
                      <div class="whitespace-free grid-bleed">
                        <xsl:call-template name="tokenize">
                          <xsl:with-param name="text" select="$options" />
                          <xsl:with-param name="delimiter" select="';'" />
                          <xsl:with-param name="separator" select="''" />
                          <xsl:with-param name="wrapper"><xsl:text disable-output-escaping="yes"><![CDATA[
                            <div class="col-xs-6">
                              <label class="]]></xsl:text>
                                <xsl:value-of select="$type" />
                                <xsl:text disable-output-escaping="yes"><![CDATA[">
                                <input type="]]></xsl:text>
                                <xsl:value-of select="$type" />
                                <xsl:text disable-output-escaping="yes"><![CDATA[" name="]]></xsl:text>
                                <xsl:value-of select="$name" />
                                <xsl:text disable-output-escaping="yes"><![CDATA[" value="$token"]]></xsl:text>
                                <xsl:if test="$required">
                                  <xsl:text disable-output-escaping="yes"><![CDATA[ required]]></xsl:text>
                                </xsl:if>
                                <xsl:text disable-output-escaping="yes"><![CDATA[ />
                                <span class="form-label">$token</span>
                              </label>
                            </div>
                          ]]></xsl:text>
                          </xsl:with-param>
                        </xsl:call-template>
                      </div>
                    </div>
                  </div>
                </div>
              </xsl:when>
              <xsl:otherwise>
                <label>
                  <xsl:attribute name="class">
                    <xsl:choose>
                      <xsl:when test="$type = 'radio' or $type = 'checkbox'">
                        <xsl:value-of select="$type" />
                      </xsl:when>
                      <xsl:otherwise>form-group</xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="$type = 'honeypot'">
                      <xsl:text> cheeze</xsl:text>
                    </xsl:if>
                    <xsl:if test="$type = 'textarea'">
                      <xsl:text> multiline</xsl:text>
                    </xsl:if>
                  </xsl:attribute>

                  <xsl:if test="$type = 'hidden' or $type = 'honeypot'">
                    <xsl:attribute name="hidden"></xsl:attribute>
                  </xsl:if>

                  <xsl:if test="$type = 'textarea'">
                    <span class="form-label">
                      <xsl:value-of select="normalize-space($label)" />
                    </span>
                  </xsl:if>

                  <xsl:call-template name="input">
                    <xsl:with-param name="tag" select="$tag" />
                    <xsl:with-param name="type" select="$type" />
                    <xsl:with-param name="name" select="$name" />
                    <xsl:with-param name="value" select="substring-before(substring-after(., 'value:'), '|')" />
                    <xsl:with-param name="placeholder" select="$label" />
                    <xsl:with-param name="required" select="contains(., 'required:1')" />
                    <xsl:with-param name="options" select="$options" />
                    <xsl:with-param name="class">
                      <xsl:choose>
                        <xsl:when test="$type = 'checkbox' or $type = 'radio' or $type = 'file'"></xsl:when>
                        <xsl:otherwise>form-control</xsl:otherwise>
                      </xsl:choose>
                    </xsl:with-param>
                  </xsl:call-template>

                  <xsl:if test="$type != 'textarea'">
                    <span class="form-label">
                      <xsl:value-of select="normalize-space($label)" />
                    </span>
                  </xsl:if>

                </label>
              </xsl:otherwise>
            </xsl:choose>

          </div>
        </xsl:for-each>

        <div class="col-sm-12 col-md-10 col-bleed-y">

          <button type="submit">
            <xsl:value-of select="normalize-space($fields[@name = 'submit'])" />
          </button>
        </div>

        <xsl:if test="$fields[@name = 'footer'] != ''">
          <div class="col-sm-12 col-md-10">
            <xsl:value-of select="$fields[@name = 'footer']" disable-output-escaping="yes" />
          </div>
        </xsl:if>

      </div>

    </form>
  </xsl:template>

  <xsl:template match="chunk[chunkData[@type = 'Place']]" mode="entity">
    <xsl:param name="width" select="500" />
    <xsl:param name="height" select="400" />
    <xsl:param name="zoom" select="15" />
    <xsl:param name="scale" />
    <xsl:param name="format" />
    <xsl:param name="maptype" />
    <xsl:param name="style" />
    <xsl:param name="key" select="'AIzaSyCPVhgCrbKphv-w7237f12b3huFVJTg21w'" />
    <xsl:param name="intrinsic-ratio" select="'4x3'" />

    <xsl:variable name="fields" select="./chunkData/field" />
    <xsl:variable name="address">
      <xsl:value-of select="normalize-space($fields[@name = 'address.streetAddress'])" />
      <xsl:text>, </xsl:text>
      <xsl:value-of select="normalize-space($fields[@name = 'address.addressLocality'])" />
      <xsl:text>, </xsl:text>
      <xsl:value-of select="normalize-space($fields[@name = 'address.addressRegion'])" />
      <xsl:text> </xsl:text>
      <xsl:value-of select="normalize-space($fields[@name = 'address.postalCode'])" />
    </xsl:variable>

    <div class="intrinsic-container intrinsic-container-{$intrinsic-ratio}">
      <xsl:call-template name="google-embedded-map">
        <xsl:with-param name="address">
          <xsl:choose>
            <xsl:when test="normalize-space($fields[@name = 'name']) != ''">
              <xsl:value-of select="concat(normalize-space($fields[@name = 'name']), ',', $address)" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$address" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
        <xsl:with-param name="width" select="$width" />
        <xsl:with-param name="height" select="$height" />
      </xsl:call-template>
    </div>
  </xsl:template>
</xsl:stylesheet>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="chunk[chunkData[@type = 'Person']]" mode="chunk">
    <xsl:param name="siblings" select="." />
    <xsl:if test="position() = 1">
      <section class="people">
        <div class="container">
          <div class="row">
            <xsl:apply-templates select="$siblings" mode="person">
              <xsl:sort select="@sequence" order="ascending" data-type="number" />
              <xsl:with-param name="style_formats" select="'.style-formats'" />
            </xsl:apply-templates>
          </div>
        </div>
      </section>
    </xsl:if>
  </xsl:template>

  <xsl:template match="chunk" mode="person">
    <xsl:variable name="name" select="chunkData/field[@name='Name']/text()"/>
    <xsl:variable name="position" select="chunkData/field[@name='Position']/text()"/>
    <xsl:variable name="photo" select="chunkData/field[@name='Photo']/text()"/>
    <xsl:variable name="fid" select="translate($name,concat($ucase,'.,'),$lcase)" />
    <!-- <xsl:variable name="bActive" select="./mode = 'edit' or ( count($siblings[./mode = 'edit']) = 0 and position() = 1)" /> -->
    <div class="col-md-4 col-xs-6">
      <a href="#{$fid}" rel="lightbox">
        <img class="full-width" title="{$name}" src="{$photo}" alt="{$name}" />
      </a>
      <h3>
        <a href="#{$fid}" rel="lightbox">
          <xsl:value-of select="$name" disable-output-escaping="yes" />
        </a>
      </h3>
      <p>
        <xsl:value-of select="$position" disable-output-escaping="yes" />
      </p>
      <div class="bio-detail" id="{$fid}">
        <div class="row group">
          <div class="col-sm-4">
            <img class="full-width" title="{$name}" src="{$photo}" alt="{$name}" />
          </div>
          <div class="col-sm-8">
            <h1><xsl:value-of select="$name" disable-output-escaping="yes" /><br />
            <span class="label"><xsl:value-of select="$position" disable-output-escaping="yes" /></span></h1>
            <xsl:apply-templates select=".">
              <xsl:with-param name="context" select="'.cell'" />
              <xsl:with-param name="style_formats" select="'.style-formats'" />
            </xsl:apply-templates>
          </div>
        </div>
      </div>
    </div>

    <!-- <xsl:choose>
      <xsl:when test="position() = last()">
        <div class="clearfix bottom-3x" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="position() mod 2 = 0">
          <div class="clearfix visible-sm-block bottom-3x" />
        </xsl:if>
        <xsl:if test="position() mod 3 = 0">
          <div class="clearfix visible-md-block visible-lg-block visible-lg-block bottom-3x" />
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose> -->

  </xsl:template>

</xsl:stylesheet>

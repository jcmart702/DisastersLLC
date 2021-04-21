<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="./chunks.xsl" />

  <xsl:variable name="STYLES">{
    "featured": "Featured Intro Section",
    "banner": "Full-width Banner",
    "header": "Title Header",
    "background-light-grey": "Light Grey Background",
    "background-light-tan": "Light Tan Background",
    "background-light-tan-equal": "Light Tan Two-Column Background",
    "background-olive": "Olive Background",
    "background-olive-equal": "Olive Two-Column Background",
    "background-light-olive": "Light Olive Background",
    "background-light-olive-equal": "Light Olive Two-Column Background",
    "background-white": "White Background",
    "background-white-equal": "White Two-Column Background",
    "background-dark-green": "Dark Green Background",
    "background-marquee-swirl": "Marquee Header Swirl Background",
    "background-left-swirl": "Left Swirl Background",
    "background-right-swirl": "Right Swirl Background"
  }</xsl:variable>

  <xsl:template match="chunk" mode="bucket">
    <xsl:param name="class" />
    <xsl:param name="chunks" />
    <xsl:variable name="bucket" select="./meta[@name = 'Content-Group']/value" />

    <section>
      <xsl:attribute name="class">
        <xsl:value-of select="translate($bucket, concat($uppercase, ' '), concat($lowercase, '-'))" />
        <xsl:if test="$class != ''">
          <xsl:value-of select="concat(' ', $class)" />
        </xsl:if>
      </xsl:attribute>

      <xsl:apply-templates
        select="$chunks"
        mode="chunk-handler">
        <xsl:sort select="@sequence" order="ascending" data-type="number" />
        <xsl:with-param name="style_formats" select="'#style-formats'" />
        <xsl:with-param name="styles" select="$STYLES" />
        <xsl:with-param name="wrapper"><xsl:text disable-output-escaping="yes"><![CDATA[
        <div class="$styles">
          <div class="container">$body</div>
        </div>
        ]]></xsl:text></xsl:with-param>
        <xsl:with-param name="siblings" select="$chunks" />
      </xsl:apply-templates>

    </section>
  </xsl:template>

  <!-- Jumbotron -->
  <xsl:template
    match="/SAM/page/chunk[
      ./meta[@name = 'Content-Group']/value = 'Marquee'
      and contains(./body, '&lt;figure class=&quot;image')
    ]"
    mode="bucket">
    <xsl:variable name="bucket" select="./meta[@name = 'Content-Group']/value" />

    <section class="marquee jumbotron">
      <xsl:call-template name="bucket-handler">
        <xsl:with-param name="bucket-label" select="$bucket"/>
        <xsl:with-param name="style_formats" select="'#style-formats'" />
        <xsl:with-param name="styles">{
          "reversed": "Reversed Content Direction"
        }
        </xsl:with-param>
        <xsl:with-param name="wrapper"><xsl:text disable-output-escaping="yes"><![CDATA[
        <div class="$styles">$body</div>
        ]]></xsl:text></xsl:with-param>
      </xsl:call-template>
    </section>
  </xsl:template>

  <!-- Carousel -->
  <xsl:template
    match="chunk[
      ./meta[@name = 'Content-Group']/value = 'Marquee'
      and ./following-sibling::chunk[1]/meta[@name = 'Content-Group']/value = 'Marquee'
    ]"
    mode="bucket">
    <section class="marquee carousel slide" id="marquee-carousel" data-ride="carousel">
      <!-- Indicators -->
      <ol class="carousel-indicators">
        <li data-target="#marquee-carousel" data-slide-to="0" class="active"></li>
        <li data-target="#marquee-carousel" data-slide-to="1"></li>
        <li data-target="#marquee-carousel" data-slide-to="2"></li>
      </ol>

      <!-- Wrapper for slides -->
      <div class="container">
        <div class="carousel-inner" role="listbox">
          <xsl:call-template name="bucket-handler">
            <xsl:with-param name="bucket-label" select="'Marquee'"/>
            <xsl:with-param name="wrapper">
              <xsl:text disable-output-escaping="yes"><![CDATA[
                <div class="item">$body</div>
              ]]></xsl:text>
            </xsl:with-param>
          </xsl:call-template>
        </div>
      </div>

      <!-- Controls -->
      <a class="left carousel-control" href="#marquee-carousel" role="button" data-slide="prev">
        <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
        <span class="sr-only">Previous</span>
      </a>
      <a class="right carousel-control" href="#marquee-carousel" role="button" data-slide="next">
        <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
        <span class="sr-only">Next</span>
      </a>
    </section>
  </xsl:template>

  <xsl:template match="chunk[./meta[@name = 'Content-Group']/value = 'Two Column']" mode="bucket">
    <xsl:param name="chunks" />

    <section class="two-column">
      <xsl:for-each select="$chunks[position() mod 2 = 1]">
        <!-- position() returns the position inside for-each, and we know this
        loop is for each item mod 2, so we do some math to get actual position
        of the chunk in $chunks. -->
        <xsl:variable name="position" select="position() * 2 - 1" />
        <xsl:variable name="next" select="$chunks[position() = $position + 1]" />
        <div class="{./meta[@name='Styles']/value}">
          <div class="container">
            <div class="grid">
              <xsl:attribute name="class">
                <xsl:text>grid</xsl:text>
                <xsl:if test="contains(./body, '&lt;img class=&quot;cover') or contains($next/body, '&lt;img class=&quot;cover')">
                  <xsl:text> grid--cover</xsl:text>
                </xsl:if>
              </xsl:attribute>
              <xsl:apply-templates
                select=".|$next"
                mode="chunk-handler">
                <xsl:sort select="@sequence" order="ascending" data-type="number" />
                <xsl:with-param name="style_formats" select="'#style-formats'" />
                <xsl:with-param name="styles" select="$STYLES" />
                <xsl:with-param name="wrapper"><xsl:text disable-output-escaping="yes"><![CDATA[
                <div class="col-sm-6"><div class="container">$body</div></div>
                ]]></xsl:text></xsl:with-param>
              </xsl:apply-templates>
            </div>
          </div>
        </div>
      </xsl:for-each>
    </section>
  </xsl:template>

  <xsl:template match="chunk[./meta[@name = 'Content-Group']/value = 'Three Column']" mode="bucket">
    <xsl:param name="chunks" />

    <section class="three-column">
      <xsl:for-each select="$chunks[position() mod 3 = 1]">
        <!-- position() returns the position inside for-each, and we know this
        loop is for each item mod 2, so we do some math to get actual position
        of the chunk in $chunks. -->
        <xsl:variable name="position" select="position() * 3 - 2" />
        <xsl:variable name="next" select="$chunks[position() = $position + 1 or position() = $position + 2]" />
        <!-- <xsl:value-of select="count($next)"></xsl:value-of> -->
        <div class="{./meta[@name='Styles']/value}">
          <div class="container">
            <div class="grid">
              <xsl:attribute name="class">
                <xsl:text>grid</xsl:text>
                <xsl:if test="contains(./body, '&lt;img class=&quot;cover') or contains($next/body, '&lt;img class=&quot;cover')">
                  <xsl:text> grid--cover</xsl:text>
                </xsl:if>
              </xsl:attribute>
              <xsl:apply-templates
                select=".|$next"
                mode="chunk-handler">
                <xsl:sort select="@sequence" order="ascending" data-type="number" />
                <xsl:with-param name="style_formats" select="'#style-formats'" />
                <xsl:with-param name="styles" select="$STYLES" />
                <xsl:with-param name="wrapper"><xsl:text disable-output-escaping="yes"><![CDATA[
                <div class="col-sm-4"><div class="container">$body</div></div>
                ]]></xsl:text></xsl:with-param>
              </xsl:apply-templates>
            </div>
          </div>
        </div>
      </xsl:for-each>
    </section>
  </xsl:template>

  <!-- Page with aside -->
  <xsl:template
    match="chunk[
      ./meta[@name = 'Content-Group']/value = 'Inline'
      and ./following-sibling::chunk[meta[@name = 'Content-Group']/value = 'Aside'][1]
    ]"
    mode="bucket">
    <xsl:param name="chunks" />

    <xsl:text disable-output-escaping="yes"><![CDATA[<div class="container"><div class="grid">]]></xsl:text>

    <section class="col-md-9 inline">
      <xsl:apply-templates
        select="$chunks"
        mode="chunk-handler">
        <xsl:sort select="@sequence" order="ascending" data-type="number" />
        <xsl:with-param name="style_formats" select="'#style-formats'" />
        <xsl:with-param name="styles" select="$STYLES" />
      </xsl:apply-templates>
    </section>

  </xsl:template>

  <xsl:template match="chunk[./meta[@name = 'Content-Group']/value = 'Aside']" mode="bucket">
    <aside class="col-md-3" role="complementary">
      <xsl:call-template name="bucket-handler">
        <xsl:with-param name="bucket-label" select="'Aside'"/>
      </xsl:call-template>
    </aside>

    <xsl:text disable-output-escaping="yes"><![CDATA[</div></div>]]></xsl:text>

  </xsl:template>

</xsl:stylesheet>

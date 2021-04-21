<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:svg="http://www.w3.org/2000/svg"
  exclude-result-prefixes="svg xlink">

  <xsl:import href="../express/page.xsl"/>
  <xsl:import href="critical-css.xsl" />
  <xsl:import href="utilities.xsl" />
  <xsl:import href="style-formats.xsl" />
  <xsl:import href="widgets.xsl" />
  <xsl:import href="header.xsl" />
  <xsl:import href="main.xsl" />
  <xsl:import href="footer.xsl" />

  <xsl:variable name="style-formats"><xsl:call-template name="style-formats"/></xsl:variable>
  <xsl:variable name="homepage" select="/SAM/navigation/link[@id = $home-id]" />

  <xsl:template match="/SAM" mode="head">

    <!-- Google Tag Manager -->
    <xsl:if test="/SAM/@directive = 'publish'">
      <script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
      new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
      j=d.createElement(s),dl=l!='dataLayer'?'&amp;l='+l:'';j.async=true;j.src=
      'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
      })(window,document,'script','dataLayer','GTM-PNK9Z4K');</script>
    </xsl:if>
    <!-- End Google Tag Manager -->

    <link
      rel="stylesheet"
      type="text/css"
      href="/css/drs.css"
      media="all" />

    <link
      rel="stylesheet"
      type="text/css"
      href="https://fonts.googleapis.com/css?family=Lato:300,400,500,700,900"
    />

    <link
      rel="stylesheet"
      type="text/css"
      href="https://fonts.googleapis.com/css?family=Crimson+Text:400,600,700"
      />

    <link
    rel="stylesheet"
    href="https://use.typekit.net/spm4ubt.css"
    />

    <xsl:if test="/SAM/@directive != 'publish'">
      <link
        rel="stylesheet"
        type="text/css"
        href="/css/sam.css"
        media="screen" />

      <script type="text/template" id="style-formats">
        <xsl:value-of select="$style-formats"/>
      </script>

    </xsl:if>
  </xsl:template>

  <xsl:template match="/SAM" mode="body">
    <xsl:if test="/SAM/@directive = 'publish'">
    <!-- Google Tag Manager (noscript) -->
      <noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-PNK9Z4K"
      height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
    <!-- End Google Tag Manager (noscript) -->
    </xsl:if>


    <input type="checkbox" id="searching" hidden="hidden" />
    <input type="checkbox" id="primary-nav-toggle" hidden="hidden" />

    <xsl:if test="count(./page/chunk[meta[@name='Content-Group']/value = 'Notice']) &gt; 0">
      <div class="page-message">
        <xsl:call-template name="bucket-handler">
          <xsl:with-param name="bucket-label">Notice</xsl:with-param>
        </xsl:call-template>
      </div>
    </xsl:if>

    <div class="page-container">
      <!-- Use template in _layout. -->
      <xsl:apply-templates select="page">
      </xsl:apply-templates>

      <xsl:if test="/SAM/@directive = 'admin'">
        <div class="debug-grid" style="display: none;">
          <div class="container">
            <div class="grid show-grid">
              <div class="col-1"></div>
              <div class="col-1"></div>
              <div class="col-1"></div>
              <div class="col-1"></div>
              <div class="col-1"></div>
              <div class="col-1"></div>
              <div class="col-1"></div>
              <div class="col-1"></div>
              <div class="col-1"></div>
              <div class="col-1"></div>
              <div class="col-1"></div>
              <div class="col-1"></div>
            </div>
          </div>
        </div>
      </xsl:if>
    </div>

    <xsl:if test="$local and $local != 'false'">
      <script src="/js/modernizr.js" async="async"></script>

      <script type="text/javascript" src="/node_modules/cash-dom/dist/cash.js"></script>
      <script type="text/javascript" src="/js/drs.js"></script>

      <xsl:if test="/SAM/@directive = 'admin'">
        <script type="text/javascript" src="/js/sam.js"></script>
      </xsl:if>
    </xsl:if>

    <xsl:if test="not($local) or $local = 'false'">
      <script src="/js/modernizr.min.js" async="async"></script>
      <script src="/js/polyfills.min.js" async="async"></script>
      <script type="text/javascript" src="/js/drs.min.js" async="async"></script>

      <xsl:if test="/SAM/@directive = 'admin'">
        <script type="text/javascript" src="/js/sam.min.js"></script>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template match="SAM" mode="subpages">
    <nav class="subpages" style="position: relative; background-color: white;">
      <ul class="container" style="padding:20px;border:1px solid gainsboro;">
        <li style="display: inline-block;">Subpages:</li>
        <xsl:for-each select="/SAM/navigation/link[@parent-id = /SAM/page/@id]">
          <xsl:sort select="@sequence" data-type="number" order="ascending" />
          <li style="display: inline-block;"><xsl:call-template name="navigation-link" /><xsl:text>  |  </xsl:text></li>
        </xsl:for-each>
      </ul>
    </nav>
  </xsl:template>
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<!-- <!DOCTYPE xsl:stylesheet [
  <!ENTITY bucket "./meta[@name = 'Content-Group']/value">
]> -->
<!--
Starter stylesheet to get you started on your new site.

This stylesheet demonstrates various ways to extend the default _layout.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!--
  We start by importing the "_layout.xsl" as the base. It gives us the
  following HTML structure:

  ```
  <html>
    <head>
      ...
      {<xsl:apply-templates mode="head" />}
      <xsl:call-template name="getStyles" />
      {/<xsl:apply-templates mode="head" />}
      ...
    </head>
    <body>
      <xsl:apply-templates mode="SAM-admin" />

      {<xsl:apply-templates mode="body" />}
      <div class="page-container" id="top">
        {<xsl:apply-templates select="page" />}
        <main class="page-content">
          <xsl:apply-templates select="chunk[...]" mode="bucket" />
        </main>
        {/<xsl:apply-templates select="page" />}
      </div>
      {/<xsl:apply-templates mode="body" />}
    </body>
  </html>
  ```
  -->
  <xsl:import href="../_layout.xsl"/>
  <xsl:import href="styles.xsl"/>
  <xsl:import href="header.xsl"/>
  <xsl:import href="main.xsl"/>
  <xsl:import href="footer.xsl"/>

  <xsl:variable name="ucase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ /\'" />
  <xsl:variable name="lcase" select="'abcdefghijklmnopqrstuvwxyz_-'" />

  <xsl:variable name="gtm-id">XXX-XXXXXXX</xsl:variable>
  <xsl:variable name="style-formats"><xsl:call-template name="style-formats"/></xsl:variable>
  <xsl:param name="local" select="false()" />

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

    <link rel="stylesheet" href="//fonts.googleapis.com/css?family=Open+Sans:300,300italic,400,400italic,600,600italic,700,700italic,800,800italic%7CRoboto:100,100italic,300,300italic,regular,italic,500,500italic,700,700italic,900,900italic"/>
    <xsl:if test="not($local) or $local = 'false'">
      <!-- Place critical CSS for above-the-fold content as inline here. -->
      <!-- <xsl:call-template name="critical-css"/> -->
      <link
          rel="stylesheet preload"
          href="/css/express/express.min.css"
          as="style"
          media="screen" />
    </xsl:if>

    <!-- <xsl:choose>
      <xsl:when test="$directive = 'admin'">
        <style>
          .samadmin .less-error-message {
            top: 65px;
            position: relative;
          }
        </style>

        <link rel="stylesheet/less" type="text/css" href="/src/styles/screen.less" media="screen" />
        <link rel="stylesheet/less" type="text/css" href="/src/styles/print.less" media="print" />
        <script type="text/javascript">
          less = {
              env: "development", // or "production"
              async: false,       // load imports async
              logLevel: 1,        // only show errors
              fileAsync: false,   // load imports async when in a page under
                                  // a file protocol
              poll: 1000,         // when in watch mode, time in ms between polls
              functions: {},      // user functions, keyed by name
              dumpLineNumbers: "comments", // or "mediaQuery" or "all"
              relativeUrls: false,// whether to adjust url's to be relative
                                  // if false, url's are already relative to the
                                  // entry less file
          };
        </script>
        <script type="text/javascript" src="/js/less.min.js"></script>
      </xsl:when>
      <xsl:otherwise>
        <link rel="stylesheet" type="text/css" href="/css/dist/screen.min.css" media="screen" />
        <link rel="stylesheet" type="text/css" href="/css/dist/print.min.css" media="print" />
      </xsl:otherwise>
    </xsl:choose> -->
  </xsl:template>

  <!--
  Most pages will have `<script/>` tags at the end before the closing
  `<body>` tag, so we need to override template rule for "body" mode.
  Because we want them outside `.page-container`, we simply use
  `<xsl:apply-imports/>` to place `.page-container` as is, and put
  the scripts below.
  -->
  <xsl:template match="/SAM" mode="body">
    <!-- Google Tag Manager (noscript) -->
      <noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-PNK9Z4K"
      height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
    <!-- End Google Tag Manager (noscript) -->

    <!-- Place scripts after `.page-container` generated by `apply-imports` -->
    <xsl:apply-imports/>

    <xsl:if test="@directive = 'admin'">
      <pre class="style-formats"><xsl:value-of select="$style-formats"/></pre>
      <xsl:apply-templates select="/SAM" mode="subpages"/>
    </xsl:if>


    <xsl:choose>
      <!-- Locally, we load both critical.less and be2017.less so we don't have to build. -->
      <xsl:when test="$local and $local != 'false'">
        <style>
          .samadmin .less-error-message {
            top: 65px;
            position: relative;
          }
        </style>

        <!-- <link rel="stylesheet/less" type="text/css" href="/_styles/critical.less" media="screen" /> -->
        <link rel="stylesheet/less" type="text/css" href="/_styles/express.less" media="screen" />
        <!-- <link rel="stylesheet/less" type="text/css" href="/_styles/print.less" media="print" /> -->
        <script type="text/javascript">
          less = {
              env: "development", // or "production"
              async: false,       // load imports async
              logLevel: 1,        // only show errors
              fileAsync: true,   // load imports async when in a page under
                                  // a file protocol
              poll: 1000,         // when in watch mode, time in ms between polls
              functions: {},      // user functions, keyed by name
              dumpLineNumbers: "comments", // or "mediaQuery" or "all"
              relativeUrls: false,// whether to adjust url's to be relative
                                  // if false, url's are already relative to the
                                  // entry less file
          };
        </script>
        <script type="text/javascript" src="/node_modules/less/dist/less.min.js"></script>
        <script type="text/javascript" src="/node_modules/jquery/dist/jquery.js"></script>
        <script type="text/javascript" src="/node_modules/featherlight/release/featherlight.min.js"></script>

      </xsl:when>

      <xsl:otherwise>

        <!--
        Load non-critical styles asynchronously using preload pattern.
        In browsers that support it, the rel=preload attribute will
        cause the browser to fetch the stylesheet, but it will not
        apply the CSS once it is loaded (it merely fetches it). To
        address this, we use an onload attribute on the link that will
        do that for us as soon as the CSS finishes loading.
        -->

        <!--
        Above step requires JavaScript to be enabled, so we include
        an ordinary reference to your stylesheet inside a noscript
        element as a fallback.
        -->
        <noscript>
          <link rel="stylesheet" type="text/css" href="/css/express/express.min.css" media="screen" />
          <!-- <link rel="stylesheet" type="text/css" href="/css/be2017/print.min.css" media="print" /> -->
        </noscript>

        <!-- <script type="text/javascript" src="/js/express/express.min.js" async="async"></script> -->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
  Similarly, pages can have a header above main and/or footer after it.
  We can continue to use `<xsl:apply-imports/>` as placeholder for the
  main element, and put header and footer before and after it.

  We can also set or change attributes of the wrapping `div`.
  -->
  <xsl:template match="SAM/page">
    <xsl:attribute name="id">top</xsl:attribute>

    <xsl:comment>googleoff: index</xsl:comment>

    <header class="site-header navbar" role="banner">
      <xsl:apply-templates select="." mode="header" />
    </header>

    <xsl:comment>googleon: index</xsl:comment>

    <main class="page-content">
      <xsl:apply-templates select="." mode="main-content" />
    </main>

    <xsl:comment>googleoff: index</xsl:comment>

    <footer class="site-footer" role="contentinfo">
      <xsl:apply-templates select="." mode="footer" />
    </footer>

    <xsl:if test="/SAM/@directive = 'admin'">
      <xsl:apply-templates select="/SAM" mode="subpages"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="SAM" mode="subpages">
    <nav class="subpages" style="position: relative; background-color: white;">
      <ul class="container" style="padding:20px;border:1px solid gainsboro;">
        <li>Subpages:</li>
        <xsl:for-each select="/SAM/navigation/link[@parent-id = /SAM/page/@id]">
          <xsl:sort select="@sequence" data-type="number" order="ascending" />
          <li><xsl:call-template name="navigation-link" /></li>
        </xsl:for-each>
      </ul>
    </nav>
  </xsl:template>
</xsl:stylesheet>

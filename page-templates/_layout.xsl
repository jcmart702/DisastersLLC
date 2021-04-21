<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!--
  This is the layout template which defines the common HTML structure.
  We can define new XSL template file, declare it in database, and import
  this layout template.

  This template exposes a few sections, which can be overridable in other
  template by using `<xsl:apply-templates>` with the corresponding `mode`:

  - "favicons": where favicons are defined.
  - "head": where stylesheets and head scripts are defined.
  - "SAM-admin": where SAM's admin bar is rendered - usually no need to override.
  - "body": the body content.
  - "page": The main content of the page.

  The "SAM-admin" mode is there to reset the matching scope for `SAM-admin`
  template to "/SAM" since a few calls in there don't have full XPath.

  See page.xsl for a walkthrough on how to overriding the rules in here.
  -->

  <!-- Imports SAM XSL templates -->
  <xsl:import href="../admin/xsl-library/master-import.xsl" />

  <!-- Set the character set -->
  <xsl:output method="html" encoding="utf-8" indent="yes" media-type="text/html; charset=utf-8" />

  <!-- Params that are passed to XSL from SAM -->
  <xsl:param name="browsemode" select="'edit'" />
  <xsl:param name="userlogin" select="1" />
  <xsl:param name="version" select="xxx" />
  <xsl:param name="menumode" select="1" />
  <xsl:param name="bucket" select="Inline" />
  <xsl:param name="debug" select="1" />
  <xsl:param name="debugtext" select="1" />
  <xsl:param name="messagetext" />
  <xsl:param name="action" />
  <xsl:param name="cwidth" />

  <!-- Some handy variables for later -->
  <xsl:variable name="directive" select="/SAM/@directive" />
  <xsl:variable name="page-id"><xsl:value-of select="/SAM/page/@id"/></xsl:variable>
  <xsl:variable name="home-id"><xsl:value-of select="/SAM/page/navigation/breadcrumb[position() = 2]/@link-id" /></xsl:variable>
  <xsl:variable name="primary-id"><xsl:value-of select="/SAM/page/navigation/breadcrumb[position() = 3]/@link-id" /></xsl:variable>
  <xsl:variable name="secondary-id"><xsl:value-of select="/SAM/page/navigation/breadcrumb[position() = 4]/@link-id" /></xsl:variable>
  <xsl:variable name="has-sidebar"><xsl:if test="count(/SAM/page/chunk/meta[@name='Content-Group' and value='Sidebar']) &gt; 0">true</xsl:if></xsl:variable>
  <xsl:variable name="depth"><xsl:value-of select="/SAM/page/navigation/breadcrumb[position() = last()]/@depth" /></xsl:variable>

  <xsl:variable name="parent" select="/SAM/navigation/link[@id = ../link[@id = $page-id]/@parent-id]" />

  <xsl:variable name="site" select="/SAM/sites/site[@root-pageid = $home-id]" />
  <xsl:variable name="root-path"><xsl:choose>
    <xsl:when test="$directive = 'publish'"><xsl:value-of select="$site/publish-url"/></xsl:when>
    <xsl:when test="$directive = 'staging'"><xsl:value-of select="$site/stage-url"/></xsl:when>
    <xsl:otherwise></xsl:otherwise>
  </xsl:choose></xsl:variable>

  <xsl:variable name="body-class">pid<xsl:value-of select="$page-id" /> sam<xsl:value-of select="$directive"/>
    <xsl:if test="$page-id != $home-id"> depth<xsl:value-of select="$depth" /></xsl:if>
    <xsl:if test="$primary-id != ''"> primary<xsl:value-of select="$primary-id" /> </xsl:if>
    <xsl:if test="$secondary-id != ''"> secondary<xsl:value-of select="$secondary-id" /> </xsl:if>
    <xsl:if test="$page-id = $home-id"> home</xsl:if>
    <xsl:if test="$has-sidebar = 'true'"> has-sidebar</xsl:if>
    <xsl:value-of select="concat(' ', translate(substring-before(/SAM/page/apply-template, '.xsl'), '/', '-'))"/>
    <xsl:if test="/SAM/page/keywords != ''"><xsl:value-of select="concat(' ', /SAM/page/keywords)"/></xsl:if>
  </xsl:variable>

  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
  <xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'" />

  <xsl:key name="kChunkByBucket" match="SAM/page/chunk" use="meta[@name = 'Content-Group']/value"/>

  <!-- The entry point for the template -->
  <xsl:template match="/">

    <!-- Set the DOCTYPE targeting HTML5 -->
    <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html></xsl:text>

    <!-- HTML tag with conditional classes for "those" browsers -->
    <xsl:text disable-output-escaping='yes'><![CDATA[
      <!--[if lt IE 7 ]><html lang="en" class="ie6"> <![endif]-->
      <!--[if IE 7 ]><html lang="en" class="ie7"> <![endif]-->
      <!--[if IE 8 ]><html lang="en" class="ie8"> <![endif]-->
      <!--[if IE 9 ]><html lang="en" class="ie9"> <![endif]-->
      <!--[if (gt IE 9)|!(IE)]><!--><html lang="en"><!--<![endif]-->
    ]]></xsl:text>

      <head>
        <xsl:call-template name="head-opening"/>

        <!-- Favicon and touch icon links -->
        <xsl:apply-templates select="SAM/page" mode="favicons"/>

        <xsl:apply-templates mode="head" />
      </head>

      <body class="{$body-class}">
        <!-- SAM Administration tools -->
        <xsl:if test="$directive = 'admin'">
          <xsl:apply-templates mode="SAM-admin" />
        </xsl:if>

        <xsl:apply-templates mode="body" />
      </body>

    <!-- Closing html tag -->
    <xsl:text disable-output-escaping="yes"><![CDATA[</html>]]></xsl:text>

  </xsl:template>

  <!-- Defaults -->
  <xsl:template match="/SAM" mode="head">
    <!-- This calls all stylesheets that are linkes in SAM. Stylesheets may be linkes with sites, pages or even content chunks -->
    <xsl:call-template name="getStyles" />
  </xsl:template>

  <xsl:template match="/SAM" mode="body">
    <div class="page-container">
      <xsl:apply-templates select="page">
      </xsl:apply-templates>
    </div>
  </xsl:template>

  <!-- Catch all match for any generic page. -->
  <xsl:template match="SAM/page">
    <main class="page-content">
      <xsl:apply-templates select="." mode="main-content" />
    </main>
  </xsl:template>

  <xsl:template match="SAM/page" mode="main-content">
    <!-- This will try to match all the chunks that start a bucket. -->
    <xsl:apply-templates
      select="chunk[
        generate-id() = generate-id(
          key('kChunkByBucket', meta[@name = 'Content-Group']/value)[1]
        )
      ]"
      mode="bucket" />
  </xsl:template>

  <!-- Catch all match for any generic chunk starting a bucket. -->
  <xsl:template match="chunk" mode="bucket">
    <xsl:call-template name="bucket-handler">
      <xsl:with-param name="bucket-label" select="meta[@name = 'Content-Group']/value"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="SAM/page" mode="favicons">
    <link rel="apple-touch-icon-precomposed" sizes="57x57" href="/images/favicons/apple-touch-icon-57x57.png" />
    <link rel="apple-touch-icon-precomposed" sizes="60x60" href="/images/favicons/apple-touch-icon-60x60.png" />
    <link rel="apple-touch-icon-precomposed" sizes="72x72" href="/images/favicons/apple-touch-icon-72x72.png" />
    <link rel="apple-touch-icon-precomposed" sizes="76x76" href="/images/favicons/apple-touch-icon-76x76.png" />
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="/images/favicons/apple-touch-icon-114x114.png" />
    <link rel="apple-touch-icon-precomposed" sizes="120x120" href="/images/favicons/apple-touch-icon-120x120.png" />
    <link rel="apple-touch-icon-precomposed" sizes="144x144" href="/images/favicons/apple-touch-icon-144x144.png" />
    <link rel="apple-touch-icon-precomposed" sizes="152x152" href="/images/favicons/apple-touch-icon-152x152.png" />
    <link rel="icon" type="image/png" href="/images/favicons/favicon-16x16.png" sizes="16x16" />
    <link rel="icon" type="image/png" href="/images/favicons/favicon-32x32.png" sizes="32x32" />
    <link rel="icon" type="image/png" href="/images/favicons/favicon-96x96.png" sizes="96x96" />
    <link rel="icon" type="image/png" href="/images/favicons/favicon-128.png" sizes="128x128" />
    <link rel="icon" type="image/png" href="/images/favicons/favicon-196x196.png" sizes="196x196" />
    <meta name="application-name" content="{$site/@name}"/>
    <meta name="msapplication-TileColor" content="#FFFFFF" />
    <meta name="msapplication-TileImage" content="/images/favicons/mstile-144x144.png" />
    <meta name="msapplication-square70x70logo" content="/images/favicons/mstile-70x70.png" />
    <meta name="msapplication-square150x150logo" content="/images/favicons/mstile-150x150.png" />
    <meta name="msapplication-wide310x150logo" content="/images/favicons/mstile-310x150.png" />
    <meta name="msapplication-square310x310logo" content="/images/favicons/mstile-310x310.png" />
  </xsl:template>

  <!-- This rule is needed to reset the scope of `SAM-admin` template. -->
  <xsl:template match="/SAM" mode="SAM-admin">
    <xsl:call-template name="SAM-admin" />
  </xsl:template>

  <xsl:template match="text()"><xsl:value-of select="normalize-space(.)"/></xsl:template>

</xsl:stylesheet>

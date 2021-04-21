<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="SAM/page" mode="header">
    <div class="container">
      <div class="navbar-header">
        <button aria-controls="bs-navbar" aria-expanded="false" class="collapsed navbar-toggle" data-target="#primary-nav" data-toggle="collapse" type="button">
          <span class="sr-only">Toggle navigation</span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
        </button>

        <xsl:apply-templates select="." mode="brand-logo" />
      </div>

      <nav class="collapse navbar-collapse navbar-right" id="primary-nav">
        <!-- @TODO: Handle secondary nav. Pending PR 787. -->
        <xsl:call-template name="ulNavigation">
          <xsl:with-param name="top" select="false()" />
          <xsl:with-param name="class" select="'nav navbar-nav'" />
          <xsl:with-param name="complete" select="'true'" />
          <xsl:with-param name="depth" select="1" />
          <xsl:with-param name="suppressHidden" select="'true'" />
          <!-- <xsl:with-param name="showHome" select="$page-id != $home-id" /> -->
        </xsl:call-template>
      </nav>
    </div>
  </xsl:template>

  <xsl:template match="SAM/page" mode="brand-logo">
    <a class="navbar-brand">
      <xsl:apply-templates select="/SAM/navigation/link[@id = $home-id]" mode="navigation-href" />
      <xsl:text>Express</xsl:text>
    </a>
  </xsl:template>
</xsl:stylesheet>

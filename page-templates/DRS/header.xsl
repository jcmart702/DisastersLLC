<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:svg="http://www.w3.org/2000/svg"
  exclude-result-prefixes="svg xlink">

  <xsl:template match="SAM/page" mode="header">

    <div>
      <div class="container">
        <div class="grid navbar-header align-center">

              <a class="col-md-4 col-9 brand-logo" tabindex="0">
                <xsl:apply-templates select="/SAM/navigation/link[@id = $home-id]" mode="navigation-href" />
                <img class="hidden-searching" alt="DRS Logo" width = "124" height="47" src="/images/common/logo.svg" />
                <img class="visible-searching" alt="DRS Logo" width = "124" height="47" src ="/images/common/logo_mobile_menu.svg"/>
              </a>

          <label class="col-3 collapsed navbar-toggle"
            for="primary-nav-toggle"
            data-target="#primary-nav" data-toggle="collapse"
            aria-label="Toggle primary navigation">
            <!-- <svg width="35" height="35" focusable="false" class="icon-menu">
              <use xlink:href="/images/tsi2018.svg#menu"></use>
            </svg> -->
            <img width="60" height="60" class="icon-menu" alt="Mobile Menu Icon" src="/images/common/mobile_menu.svg"/>
            <img width="30" height="30" class="icon-close" alt="Mobile Menu Close" src="/images/common/close.svg"/>
          </label>

          <nav class="col-md-8 collapse navbar-collapse navbar-right" id="primary-nav">
            <xsl:call-template name="ulNavigation">
              <xsl:with-param name="top" select="false()" />
              <xsl:with-param name="class" select="'nav navbar-nav'" />
              <xsl:with-param name="idPrefix" select="'primary-nav-'" />
              <xsl:with-param name="complete" select="'true'" />
              <xsl:with-param name="depth" select="2" />
              <xsl:with-param name="suppressHidden" select="'true'" />
              <xsl:with-param name="showHome" select="true()" />
            </xsl:call-template>
          </nav>
        </div>
      </div>
    </div>

  </xsl:template>

  <xsl:template match="link[contains(./title, 'Search')]" mode="liNavigation">
    <li id="primary-nav-{./@id}">
      <form action="/Default.asp?pageid={./@id}" method="GET">
        <label for="searching" tabindex="0">
          <svg class="hidden-searching" width="18" height="18" role="presentation">
            <use xlink:href="/images/tsi2018.svg#search"></use>
          </svg>
          <svg class="visible-searching" width="18" height="18" role="presentation">
            <use xlink:href="/images/tsi2018.svg#close"></use>
          </svg>
        </label>

        <div class="search-box">
          <div class="container">
            <div class="form-group">
              <input type="text" name="q" autofocus="autofocus" />

              <button type="submit">
                <svg width="30" height="30" role="presentation">
                  <use xlink:href="/images/tsi2018.svg#search"></use>
                </svg>
              </button>
            </div>
          </div>
        </div>

      </form>
    </li>
  </xsl:template>

  <!-- Primary link that has navigable subpages. -->
  <xsl:template match="link[@id = /SAM/navigation/link[@navigable = 1]/@parent-id]" mode="ulNavigation">

    <!-- Full screen background -->
    <div class="secondary-nav">
      <div class="container">
        <!-- But within the page's container grid -->
        <div class="grid">
          <!-- And only takes 8 columns, offset by 4, because the primary nav is that way -->
          <nav class="col-md-8 col-md-offset-4">
            <!-- Use `call-template` here because we already within a `apply-template` -->
            <xsl:call-template name="ulNavigation">
              <xsl:with-param name="parent" select="./@id" />
              <xsl:with-param name="top" select="false()" />
              <xsl:with-param name="class" select="'nav navbar-nav'" />
              <xsl:with-param name="idPrefix" select="'secondary-nav-'" />
              <xsl:with-param name="complete" select="'false'" />
              <xsl:with-param name="depth" select="1" />
              <xsl:with-param name="suppressHidden" select="'true'" />
              <xsl:with-param name="showHome" select="false()" />
              <xsl:with-param name="showOverviews" select="true()" />
            </xsl:call-template>
          </nav>
        </div>
      </div>
    </div>
  </xsl:template>
</xsl:stylesheet>

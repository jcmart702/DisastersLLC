<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:svg="http://www.w3.org/2000/svg"
  exclude-result-prefixes="svg xlink">

  <xsl:template match="SAM/page" mode="footer">
    <div class="container">
      <div class="grid">
        <div class="col-sm-4 brand-logo vertical-padded">
          <a class="">
            <xsl:apply-templates select="/SAM/navigation/link[@id = $home-id]" mode="navigation-href" />
            <img width="92" height="92" alt="DRS Logo" src="/images/common/logo_footer.svg" />
          </a>
        </div>

        <div class="col-sm-8 vertical-padded">
          <div class="grid">
            <nav class="col-sm-3 col-6">
              <h5 class="small">Links</h5>
              <ul>
                <xsl:apply-templates
                  select="/SAM/navigation/link[@parent-id = $home-id and @navigable = 1 and @noindex != 1]"
                  mode="liNavigation">
                  <xsl:sort select="@sequence" data-type="number" order="ascending" />
                  <xsl:with-param name="count" select="4"/>
                </xsl:apply-templates>
              </ul>
            </nav>

            <nav class="col-sm-3 col-6">
              <h5 class="small">Follow</h5>
              <ul>
                <li><a href="https://www.facebook.com/drrsllc/" target="_blank">Facebook</a></li>
                <li><a href="https://www.linkedin.com/company/disaster-recovery-services-llc/about/" target="_blank">LinkedIn</a></li>
              </ul>
            </nav>

            <div class="col-sm-6">
              <h5 class="small">Connect</h5>

                <div class="contact-info">

                <xsl:variable name="contact-info" select="$homepage/pageData[@type = 'Contact Info']" />
                <xsl:variable name="email">
                  <xsl:choose>
                    <xsl:when test="$contact-info/field[@name = 'email'] != ''">
                      <xsl:value-of select="$contact-info/field[@name = 'email']" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:text>contactus@</xsl:text>
                      <xsl:variable name="hostname" select="substring-after($site/publish-url, '://')" />
                      <xsl:choose>
                        <xsl:when test="contains($hostname, 'www.')">
                          <xsl:value-of select="substring-after($hostname, 'www.')" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="$hostname" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>

                <a href="mailto:{$email}" target="_blank">
                  <xsl:value-of select="$email" />
                </a>
                <xsl:if test="$contact-info/field[@name = 'telephone'] != ''">
                  <br />
                  <xsl:value-of select="$contact-info/field[@name = 'telephone']" />
                </xsl:if>

                <p>
                  <a href="tel:833.377.4357">833.377.4357</a>
                </p>

                </div>

            </div>

            <div class="col-sm-12">
              <div class="small">
                <xsl:call-template name="bucket-handler">
                  <xsl:with-param name="bucket-label">Footer</xsl:with-param>
                </xsl:call-template>
              </div>

              <p id="Copyright">Disaster Recovery Services, LLC 2020 | <a href="Default.asp?pageid=16">PRIVACY</a> | <a href="Default.asp?pageid=17">TERMS</a></p>
              <p class="CopyMobile">Disaster Recovery Services, LLC 2020</p>
              <p class="CopyMobile" id="CopySecondLine"><a href="Default.asp?pageid=16">PRIVACY</a> | <a href="Default.asp?pageid=17">TERMS</a></p>

            </div>
          </div>
        </div>


      </div>
    </div>
  </xsl:template>

</xsl:stylesheet>

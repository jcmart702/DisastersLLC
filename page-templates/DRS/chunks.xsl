<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- So we can use <xsl:apply-imports /> for overriding chunk template. -->
  <xsl:import href="../../admin/xsl-library/presentation/text-html.xsl" />

  <xsl:key name="entity-field" match="chunkData/field" use="@name" />

  <!-- First slide. -->
  <xsl:template
    match="chunk[
      ./meta[@name = 'Content-Group']/value = 'Marquee'
      and position() = 1
      and ./following-sibling::chunk[1]/meta[@name = 'Content-Group']/value = 'Marquee'
    ]"
    mode="chunk-handler">
    <div class="active item">
      <xsl:apply-imports />
    </div>
  </xsl:template>

  <!-- Form chunk -->
  <xsl:template match="chunk[chunkData[@type = 'Form']]" mode="chunk-handler">
    <div class="form-container vertical-padded container">
      <div class="grid justify-start contact-form">
        <div class="col-sm-12 col-md-10 col-bleed-y">
          <xsl:call-template name="chunk-handler">
            <xsl:with-param name="context" select="'.form-container'" />
          </xsl:call-template>
        </div>
      </div>

      <xsl:apply-templates select="." mode="entity" />
    </div>
  </xsl:template>

  <!-- Location -->
  <xsl:template match="chunk[chunkData[@type = 'Place']]" mode="chunk-handler">
    <xsl:param name="siblings" />

    <xsl:variable name="position" select="position()" />
    <xsl:variable name="prev" select="$siblings[position() = $position - 1]" />
    <xsl:variable name="next" select="$siblings[position() = $position + 1]" />

    <xsl:if test="$prev[chunkData[@type != 'Place']] and $next[chunkData[@type = 'Place']]">
      <h1 class="centered background-medium-gray"><div class="container">Our Offices</div></h1>
    </xsl:if>

    <div vocab="http://schema.org/" typeof="Place">
      <div class="container">
        <div class="grid justify-center">
          <div class="col-sm-6 col-md-5">
            <xsl:call-template name="chunk-handler">
              <xsl:with-param name="context" select="'.grid'" />
            </xsl:call-template>

            <xsl:variable name="fields" select="./chunkData/field" />
            <p property="address" typeof="PostalAddress">
              <span property="streetAddress">
                <xsl:value-of select="normalize-space($fields[@name = 'address.streetAddress'])" />
                <xsl:if test="normalize-space($fields[@name = 'address.streetAddress2']) != ''">
                  <xsl:text>, </xsl:text>
                  <xsl:value-of select="normalize-space($fields[@name = 'address.streetAddress2'])" />
                </xsl:if>
              </span>
              <br/>
              <span property="addressLocality">
                <xsl:value-of select="normalize-space($fields[@name = 'address.addressLocality'])" />
              </span>
              <xsl:text>, </xsl:text>
              <span property="addressRegion">
                <xsl:value-of select="normalize-space($fields[@name = 'address.addressRegion'])" />
              </span>
              <xsl:text> </xsl:text>
              <span property="postalCode">
                <xsl:value-of select="normalize-space($fields[@name = 'address.postalCode'])" />
              </span>
              <br/>
              <span property="telephone">
                <xsl:value-of select="normalize-space($fields[@name = 'telephone'])" />
              </span>
            </p>
          </div>

          <div class="col-sm-6 col-md-5">
            <xsl:apply-templates select="." mode="entity" />
          </div>
        </div>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="chunk[contains(meta[@name = 'Styles']/value, 'featured')]" mode="chunk-handler">
    <xsl:param name="styles" />
    <xsl:param name="wrapper" select="'$body'" />

    <xsl:call-template name="chunk-handler">
      <xsl:with-param name="wrapper">
        <xsl:call-template name="sam-replace-string">
          <xsl:with-param name="text" select="$wrapper" />
          <xsl:with-param name="replace" select="'$body'" />
          <xsl:with-param name="with">
            <xsl:text disable-output-escaping="yes"><![CDATA[
            <div class="col-sm-10 col-sm-offset-1">$body</div>
            ]]></xsl:text>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:with-param>
      <xsl:with-param name="styles" select="$styles" />
      <xsl:with-param name="style_formats" select="'#style-formats'" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="chunk[./meta[@name = 'Content-Group']/value = 'Two Column']" mode="chunk-handler">
    <xsl:param name="wrapper" select="''" />
    <xsl:param name="styles" />

    <xsl:call-template name="chunk-handler">
      <xsl:with-param name="wrapper">
        <xsl:choose>
          <xsl:when test="contains(./body, '&lt;img class=&quot;cover') or contains(./body, '&lt;video')">
            <xsl:call-template name="sam-replace-string">
              <xsl:with-param name="text" select="$wrapper" />
              <xsl:with-param name="replace">col-sm-6</xsl:with-param>
              <xsl:with-param name="with">col-sm-6 cover-image</xsl:with-param>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$wrapper" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
      <xsl:with-param name="styles" select="$styles" />
      <xsl:with-param name="style_formats" select="'#style-formats'" />
    </xsl:call-template>
  </xsl:template>

  <!-- Hide code chunk unless we are in developer mode. -->
  <xsl:template
    match="/SAM[@directive != 'admin']/page/chunk[contains(./mime-type, 'application/')]"
    mode="chunk-handler">

    <xsl:call-template name="chunk-handler">
      <xsl:with-param name="wrapper" />
    </xsl:call-template>
  </xsl:template>

  <!-- Convert the figure.image generated by TinyMCE to card. -->
  <xsl:template
    match="page[
      @id = navigation/breadcrumb[position() = 2]/@link-id
    ]/chunk[
      ./meta[@name = 'Content-Group']/value = 'Marquee'
      and contains(body, 'figure class=&quot;image&quot;')
    ]"
    mode="chunk-body">

    <!-- Content before the figure.image. -->
    <xsl:value-of
      select="substring-before(./body, '&lt;figure class=&quot;image&quot;&gt;') "
      disable-output-escaping="yes" />

    <xsl:variable name="image"
      select="substring-before(
        substring-after(./body, '&lt;figure class=&quot;image&quot;&gt;'),
        '&lt;figcaption'
      )" />
    <xsl:variable name="src" select="substring-before(substring-after($image, 'src=&quot;'), '&quot;')" />
    <xsl:variable name="srcset">
      <xsl:call-template name="srcset">
        <xsl:with-param name="src" select="$src" />
        <xsl:with-param name="set">
          <xsl:text>/w576 576w, /w388 768w, /w496 992w, /w600 1200w, /w700 1400w, /w800 1600w, 2000w</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="figcaption" select="substring-before(substring-after(./body, $image), '&lt;/figure&gt;')" />

    <figure class="image">
      <xsl:value-of select="substring-before($image, $src)" disable-output-escaping="yes"/>
      <xsl:value-of select="$src" />
      <xsl:value-of select="concat('&quot; srcset=&quot;', $srcset, '&quot; sizes=&quot;100vw')" />
      <xsl:value-of select="substring-after($image, $src)" disable-output-escaping="yes"/>

      <xsl:value-of select="$figcaption" disable-output-escaping="yes" />
    </figure>

    <xsl:value-of
      select="substring-after(substring-after(./body, $figcaption), '&lt;/figure&gt;')"
      disable-output-escaping="yes" />
  </xsl:template>

  <!-- Wrap <video> with container and play button. -->
  <xsl:template match="chunk[contains(./body, 'video')]" mode="chunk-body">
    <xsl:call-template name="wrap-video">
      <xsl:with-param name="html" select="./body" />
    </xsl:call-template>
  </xsl:template>

  <!-- Recursively wrap <video> with proper markups. -->
  <xsl:template name="wrap-video">
    <xsl:param name="html" />

    <xsl:choose>
      <xsl:when test="contains($html, '&lt;/video&gt;&lt;/p&gt;')">
        <xsl:value-of select="substring-before($html, '&lt;p&gt;&lt;video ')" disable-output-escaping="yes" />

        <!-- The full <video> with  preload=none and controlsList=nodownload attributes. -->
        <!-- The preload=none is needed for IE9 to display the poster on initial load. -->
        <xsl:variable
          name="video"
          select="concat(
            '&lt;video preload=&quot;none&quot; controlsList=&quot;nodownload&quot; ',
            substring-before(
              substring-after(
                $html,
                '&lt;p&gt;&lt;video '
              ),
              '&lt;/video&gt;&lt;/p&gt;'
            ),
            '&lt;/video&gt;'
          )"
        />

        <xsl:variable
          name="poster"
          select="substring-before(
            substring-after($video, 'poster=&quot;'),
            '&quot;'
          )"
        />

        <!-- Retrieve the video URL from the first <source> -->
        <xsl:variable
          name="src"
          select="substring-before(
            substring-after($video, '&lt;source src=&quot;'),
            '&quot;'
          )"
        />

        <a href="{$src}" class="video-thumbnail" rel="lightbox noopener noreferrer">
          <picture>
            <source media="(max-width: 768px)">
              <xsl:attribute name="srcset">
                <xsl:call-template name="thumbnail">
                  <xsl:with-param name="url" select="$poster" />
                  <xsl:with-param name="width" select="768" />
                </xsl:call-template>
              </xsl:attribute>
            </source>
            <source media="(min-width: 769px) and (max-width: 1200px)">
              <xsl:attribute name="srcset">
                <xsl:call-template name="srcset">
                  <xsl:with-param name="src" select="$poster" />
                  <xsl:with-param name="set">
                    <xsl:text>/w480/h480 992w, /w720/h720 1200w</xsl:text>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:attribute>
            </source>
            <source media="(min-width: 1201px)">
              <xsl:attribute name="srcset">
                <xsl:call-template name="srcset">
                  <xsl:with-param name="src" select="$poster" />
                  <xsl:with-param name="set">
                    <xsl:text>/w1000 1600w, 2000w</xsl:text>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:attribute>
            </source>
            <img alt="Poster for video" class="cover">
              <xsl:attribute name="src"><xsl:value-of select="$poster"/></xsl:attribute>
            </img>
          </picture>
          <svg class="play-button" width="82" height="82" viewBox="0 0 82 82">
            <polyline fill="none" stroke="currentColor" stroke-width="2" stroke-miterlimit="10" points="34 19.3 55.7 41 34 62.7"/>
          </svg>
        </a>

        <dialog>
          <a href="#close" class="close">
            <svg width="24" height="24" role="presentation">
              <use xlink:href="/images/tsi2018.svg#close" xmlns:xlink="http://www.w3.org/1999/xlink"></use>
            </svg>
          </a>
          <div class="video-container">
            <xsl:call-template name="transform-video-source">
              <xsl:with-param name="html" select="$video" />
            </xsl:call-template>
          </div>
        </dialog>

        <!-- Wrap next video if any. -->
        <xsl:call-template name="wrap-video">
          <xsl:with-param name="html" select="substring-after($html, '&lt;/video&gt;&lt;/p&gt;')" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$html" disable-output-escaping="yes" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- In TinyMCE, we can specify ONE alternate source, so we can put the embedded YouTube URL in.
  This template will parse that <source> and replace it with <iframe> inside a <noscript>. -->
  <xsl:template name="transform-video-source">
    <xsl:param name="html" />

    <xsl:choose>

      <xsl:when test="contains($html, '&lt;source src=&quot;')">
        <xsl:variable name="content-before" select="substring-before($html, '&lt;source src=&quot;')" />

        <xsl:call-template name="transform-video-source">
          <xsl:with-param name="html" select="$content-before" />
        </xsl:call-template>

        <!-- Transform the current <source> -->
        <xsl:variable
          name="source"
          select="concat(
            '&lt;source src=&quot;',
            substring-before(substring-after($html, '&lt;source src=&quot;'), '/&gt;'),
            '/&gt;'
          )"
        />

        <xsl:variable name="content-after" select="substring-after($html, $source)" />

        <xsl:choose>

          <xsl:when test="contains($source, 'youtube.com/embed/')">
            <!-- Put the embedded iframe in a <noscript> so it won't load.
            JS will unwrap it if the browser does not support <video>. -->
            <noscript>
              <iframe
                src="{substring-before(substring-after($source, 'src=&quot;'), '&quot;')}"
                frameborder="0"
                allow="autoplay; encrypted-media"
                allowfullscreen="allowfullscreen">

              </iframe>
            </noscript>
          </xsl:when>

          <xsl:otherwise>
            <xsl:value-of select="$source" disable-output-escaping="yes" />
          </xsl:otherwise>

        </xsl:choose>

        <!-- Transform next <source> if any. -->
        <xsl:call-template name="transform-video-source">
          <xsl:with-param name="html" select="$content-after" />
        </xsl:call-template>
      </xsl:when>

      <xsl:otherwise>
        <xsl:value-of select="$html" disable-output-escaping="yes" />
      </xsl:otherwise>

    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="./index.xsl"/>

  <xsl:template match="SAM/page" mode="main-content">
    <section class="marquee background-indigo">
      <div class="container">
        <h1>Style Guide</h1>
      </div>
    </section>

    <section class="marquee jumbotron">
      <figure class="card">
        <img src="https://placeholdit.co//i/1330x600?bg=C1B1AD&amp;text=FDO" />
        <figcaption>
          <h1>
            <xsl:text>P1 55/60 FG Medium</xsl:text>
            <br />
            <xsl:text>We Need a Stronger</xsl:text>
            <br />
            <xsl:text>Word for Accuracy</xsl:text>
          </h1>
          <p><a class="call-to-action">CTA Explore Our Product or Solution</a></p>

          <p><a class="hovered call-to-action">CTA Explore Our Product or Solution</a></p>
        </figcaption>
      </figure>
    </section>

    <!-- "Inline with Aside" bucket. -->
    <section class="inline">
      <div class="background-soft-blue">
        <div class="container">
          <div class="grid">
            <div class="col-xs-4">
              <h2>P2 30/36 FG Medium Featured Row</h2>
            </div>
            <div class="col-xs-8">
              <p class="lead">Large Intro Body: 21/36 Fort Book</p>
              <p class="lead">Make a paragraph stand out by adding <code>.lead</code>. This paragraph is an example. Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor. Duis mollis, est non commodo luctus.</p>
            </div>
          </div>
        </div>
      </div>

      <div class="">
        <div class="container">
          <div class="grid">
            <div class="col-xs-4">
              <h2>Color Palette</h2>
            </div>
            <div class="col-xs-8">
              <div class="grid">
                <div class="col-4">
                  <div class="grid">
                    <h5 class="col-12">Indigo</h5>
                    <div class="col-7">
                      <p class="block-color background-indigo"></p>
                    </div>
                  </div>
                </div>
                <div class="col-4">
                  <div class="grid">
                    <h5 class="col-12">Red</h5>
                    <div class="col-7">
                      <p class="block-color background-red"></p>
                    </div>
                  </div>
                </div>
                <div class="col-4">
                  <div class="grid">
                    <h5 class="col-12">Turquoise</h5>
                    <div class="col-7">
                      <p class="block-color background-turquoise"></p>
                    </div>
                  </div>
                </div>

                <div class="col-6">
                  <div class="grid">
                    <h5 class="col-12">Soft blue</h5>
                    <div class="col-5">
                      <p class="block-color background-soft-blue-shade"></p>
                    </div>
                    <div class="col-5">
                      <p class="block-color background-soft-blue"></p>
                    </div>
                  </div>
                </div>

                <div class="col-6">
                  <div class="grid">
                    <h5 class="col-12">Light Gray</h5>
                    <div class="col-5">
                      <p class="block-color background-light-gray-shade"></p>
                    </div>
                    <div class="col-5">
                      <p class="block-color background-light-gray"></p>
                    </div>
                  </div>
                </div>

                <div class="col-4">
                  <div class="grid">
                    <h5 class="col-12">Dark Gray</h5>
                    <div class="col-7">
                      <p class="block-color background-dark-gray"></p>
                    </div>
                  </div>
                </div>
                <div class="col-4">
                  <div class="grid">
                    <h5 class="col-12">Medium Gray</h5>
                    <div class="col-7">
                      <p class="block-color background-medium-gray"></p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Two equal size column -->
    <section class="two-column">
      <div class="grid">
        <div class="col-md-6 background-indigo">
          <h4>P4 19/24 Subtitle</h4>

          <h2>P2 30/36 Chunks in "Two Column" bucket</h2>
          <p>Each boxes is a chunk in Two Column bucket. They take half the screen width, and the content is centered inside regardless of the screen size. The order of the boxed can be arranged by resequencing the chunks.</p>

          <p>
            <a class="button">16/22 Anchor link with .button class</a>
          </p>

          <p>
            <a class="hovered button">I'm being hovered</a>
          </p>
        </div>

        <div class="col-md-6 background-red">
          <h4>P4 19/24 FG Medium All Caps</h4>

          <h2>P2 Applying background color classes</h2>
          <p>The boxes can have background color applied to them. Simply right-click, choose Info, and enter either "background-indigo", "background-red", "background-turquoise", "background-light-gray", "background-medium-gray" or "background-soft-blue".</p>

          <p>
            <a class="button">16/22 I am great as a CTA</a>
          </p>

          <p>
            <a class="hovered button">I'm being hovered</a>
          </p>
        </div>
      </div>

      <div class="grid">
        <div class="col-md-6 background-medium-gray">
          <h2>P2 FG Medium 30/36</h2>
          <p>Body: Fort Book 16/30: Dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi eismod tincidunt ut laorenim ad minim ve erat vniam, quis</p>

          <p>
            <a class="button">16/22 CTA FG Medium</a>
          </p>

          <p>
            <a class="hovered button">I'm being hovered</a>
          </p>

        </div>

        <div class="col-md-6 background-light-gray">
          <h2>P2 Custom Solutions</h2>
          <p>Body: Fort Book 16/30 Dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi eismod tincidunt ut laorenim ad minim ve erat vniam, quis</p>
          <p>
            <a class="button">16/22 CTA FG Medium</a>
          </p>

          <p>
            <a class="hovered button">I'm being hovered</a>
          </p>
        </div>
      </div>
    </section>

    <!-- "Inline with Aside" bucket. -->
    <section class="inline background-light-gray">
      <div class="container">
        <div class="grid">
          <div class="col-md-8">
            <h2>P2 30/36 Inline content with a right aside</h2>

            <p>
              <xsl:text>Sometimes, we have more advanced layout such as this section </xsl:text>
              <xsl:text>or the leading intro above. They are hard to apply in the editor, </xsl:text>
              <xsl:text>so we need to use a template for it. In the editor, choose menu </xsl:text>
              <xsl:text>Insert -> Template, and choose usuable layout from there. Even </xsl:text>
              <xsl:text>though it has the preview, it's not useful when involving columns, </xsl:text>
              <xsl:text>on which many layouts are based. Therefore, just apply and see the </xsl:text>
              <xsl:text>result inside the editor. If it's not right, clear out the chunk </xsl:text>
              <xsl:text>and insert another templte.</xsl:text>
            </p>
          </div>

          <aside class="col-md-4 col-centered">
            <h4>P4 Services</h4>

            <ul>
              <li>Body + Indigo</li>
              <li>List Item 1</li>
              <li>List Item 1</li>
              <li>List Item 1</li>
              <li>List Item 1</li>
              <li>List Item 1</li>
            </ul>
          </aside>
        </div>
      </div>
    </section>

    <!-- Normal "Inline" bucket. -->
    <section class="inline">
      <div class="container">
        <div class="grid">
          <div class="col-md-8">
            <h1>P1 55/60 FG Medium</h1>

            <p class="lead">Large Intro Body: 21/36 Fort Book</p>
            <p class="lead">As the industry’s leading turnkey solution provider well into our second decade, Tubular Solutions links the critical services required for inspection, monitoring and maintenance, in order to be the ideal, 360-degree partner for all your pipe-related needs.</p>

            <h2>P2 30/36 Sub Catagroy 3</h2>
            <p>
              <xsl:text>Lorem ipsum dolor sit amet, consectetuer adipiscing elit, </xsl:text>
              <xsl:text>sed diam nonummy nibh euismod tincidunt ut laoreet dolore </xsl:text>
              <xsl:text>magna aliquam erat volutpat. Ut wisi enim ad minim veniam,</xsl:text>
              <xsl:text> quis nostrud exerci tation ullamcorper suscipit lobortis </xsl:text>
              <xsl:text>nisl ut aliquip ex ea commodo consequat. Duis autem vel </xsl:text>
              <xsl:text>eum iriure dolor </xsl:text>
              <a href="#">Body link color</a>
              <xsl:text> sit amet, adipis </xsl:text>
              <a class="hovered">Body link RO</a>
              <xsl:text> cing elit, sed diam nonummy nibh euismod tincidunt ut </xsl:text>
              <xsl:text>laoreet dolore magna aliquam erat volutpat. Ut wisi enim </xsl:text>
              <xsl:text>ad minim veniam, quis nostrud exerci tation ullamcorper </xsl:text>
              <xsl:text>suscipit lobortis nisl ut aliquip ex ea commodo consequat. </xsl:text>
              <xsl:text>Duis autem vel eum iriure dolor</xsl:text>
            </p>

            <ul>
              <li>Body plus 12 PX after the paragraph: Lorem ipsum dolor sit amet, consectetuer adipiscing elit, tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis </li>
              <li>Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis</li>
              <li>Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis</li>
            </ul>

            <h3>P3 26/30 Regular</h3>
            <p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor  Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor </p>

            <h4>P4 Services</h4>
            <p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor  Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor </p>

          </div>
        </div>
      </div>

      <div class="background-soft-blue">
      <div class="form-container container">
        <h1 id="forms">Forms</h1>
        <p>Forms can be constructed using Form entity. All textual <code>&lt;input&gt;</code>, <code>&lt;textarea&gt;</code>, and <code>&lt;select&gt;</code> elements are set to <code>width: 100%;</code> by default, with label above. <code>checkbox</code> or <code>radio</code> input has label after.</p>
        <h2 id="forms-controls">Supported Controls</h2>
        <p>
          Most common form control, text-based input fields. Includes support for all HTML5 types: <code>text</code>, <code>password</code>, <code>datetime-local</code>, <code>date</code>, <code>month</code>, <code>time</code>, <code>week</code>, <code>number</code>, <code>email</code>, <code>url</code>, <code>search</code>, <code>tel</code>, and <code>color</code>.
          <code>hidden</code> input can also be used if needed. A special type <code>honeypot</code> can be used for spam protection.
          To group checkboxes or radios, use a single <code>checkbox</code> or <code>radio</code> input, and place the values in the <code>Options</code> parameter. The <code>Label</code> will be used as the group's title.
        </p>

        <form method="POST" action="" class="" enctype="multipart/form-data">
          <label class="form-group">
            <input type="text" name="text" required="required" placeholder="Text input" class="form-control" />
            <span class="form-label">Text input</span>
          </label>

          <label class="form-group">
            <input type="number" name="number" required="required" placeholder="Number input" class="form-control" />
            <span class="form-label">Number input</span>
          </label>

          <label class="form-group">
            <input type="password" name="password" required="required" placeholder="Password" class="form-control" />
            <span class="form-label">Password</span>
          </label>

          <label class="form-group">
            <input type="phone" name="phone" required="required" placeholder="Phone number" class="form-control" />
            <span class="form-label">Phone number</span>
          </label>

          <label class="form-group">
            <input type="email" name="email" required="required" placeholder="Email address" class="form-control" />
            <span class="form-label">Email address</span>
          </label>

          <label class="form-group">
            <input type="url" name="url" required="required" placeholder="Website" class="form-control" />
            <span class="form-label">Website</span>
          </label>

          <label class="form-group">
            <input type="datetime-local" name="datetime-local" required="required" placeholder="Date time" class="form-control" />
            <span class="form-label">Date time</span>
          </label>

          <label class="form-group">
            <input type="date" name="date" required="required" placeholder="Date" class="form-control" />
            <span class="form-label">Date</span>
          </label>

          <label class="form-group">
            <input type="month" name="month" required="required" placeholder="Month" class="form-control" />
            <span class="form-label">Month</span>
          </label>

          <label class="form-group">
            <input type="time" name="time" required="required" placeholder="Time" class="form-control" />
            <span class="form-label">Time</span>
          </label>

          <label class="form-group">
            <input type="week" name="week" required="required" placeholder="Week" class="form-control" />
            <span class="form-label">Week</span>
          </label>

          <label class="form-group">
            <input type="color" name="color" required="required" placeholder="Color" class="form-control" />
            <span class="form-label">Color</span>
          </label>

          <label class="form-group">
            <input type="text" name="optional" placeholder="Non-required field" class="form-control" />
            <span class="form-label">Non-required field</span>
          </label>

          <label class="form-group">
            <select name="select" required="required" placeholder="Selection" class="form-control">
              <option disabled="disabled" selected="selected">Select one</option>
              <option value="Option A">Option A</option>
              <option value="Option B">Option B</option>
              <option value="Option C">Option C</option>
            </select>
            <span class="form-label">Selection</span>
          </label>

          <label class="checkbox">
            <input type="checkbox" name="checkbox" required="required" placeholder="Checkbox" />
            <span class="form-label">Checkbox</span>
          </label>

          <label class="radio">
            <input type="radio" name="radio" required="required" placeholder="Radiobox "/>
            <span class="form-label">Radiobox</span>
          </label>

          <label class="radio">
            <input type="radio" name="radio" required="required" placeholder="Another Radiobox with same name "/>
            <span class="form-label">Another Radiobox with same name</span>
          </label>

          <label class="form-group">
            <input type="file" name="file" required="required" placeholder="File upload "/>
            <span class="form-label">File upload</span>
          </label>

          <div class="form-group" role="group" aria-labelledby="checkboxes__label">
            <label id="checkboxes__label">Checkbox group</label>
            <label class="checkbox">
              <input type="checkbox" name="checkboxes" value="Check box 1" required="required" />
              <span class="form-label">Check box 1</span>
            </label>

            <label class="checkbox">
              <input type="checkbox" name="checkboxes" value="Check box 2" required="required" />
              <span class="form-label">Check box 2</span>
            </label>

            <label class="checkbox">
              <input type="checkbox" name="checkboxes" value="Check box 3" required="required" />
              <span class="form-label">Check box 3</span>
            </label>
          </div>

          <div class="form-group" role="group" aria-labelledby="radios__label">
            <label id="radios__label">Radio group</label>
            <label class="radio">
              <input type="radio" name="radios" value="Radio option 1" required="required" />
              <span class="form-label">Radio option 1</span>
            </label>

            <label class="radio">
              <input type="radio" name="radios" value="Radio option 2" required="required" />
              <span class="form-label">Radio option 2</span>
            </label>

            <label class="radio">
              <input type="radio" name="radios" value="Radio option 3" required="required" />
              <span class="form-label">Radio option 3</span>
            </label>
          </div>

          <label class="form-group">
            <textarea name="comment" required="required" placeholder="Textarea" rows="5" class="form-control"></textarea>
            <span class="form-label">Textarea</span>
          </label>

          <button type="submit">Submit</button>

        </form>

      </div>
      </div>
    </section>
  </xsl:template>

</xsl:stylesheet>

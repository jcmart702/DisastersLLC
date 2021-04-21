$AM(function() {
  $AM.when($AM.SAM.navigation || $AM.loadNavigationData())
  .then(function(navigation) {
    var page = $AM.SAM.page;
    var isHomepage = false;
    $AM.each(navigation, function(_, node) {
      if (isHomepage) return;
      if (node.id === page.id) {
        isHomepage = true;
      }
    });

    var entities = ["Solution", "Product"];
    if (isHomepage) {
      entities.push("Contact Info");
    }

    $AM.SAM.metadata.PageTypes = entities;

    $AM.each(entities, function pt(idx, val) {
      var fnName = val.replace(" ", "");
      $AM(document).on("click", "#samEdit" + fnName, function editPageData() {
        $AM.showFDO($AM.FDOs["edit" + fnName]);
      });
    });

    var populateEntityData = function pageData(fields) {
      var pageId = page.id;
      var sites = $AM.SAM.sites;
      var siteID = $AM.SAM.site.id;
      var navigation = $AM.SAM.navigation;

      $AM.each(fields, function eachField(key, field) {
        var name = field.name || key;
        var $field = $AM("#" + key);

        if (page.pageData && page.pageData[name]) {
          var value = page.pageData[name];
          switch (field.type) {
            case "select":
              $field.find("option[value=\"" + value + "\"]").prop("selected", true);
              break;
            case "textarea":
              $field.text(value);
              break;
            case "editable":
              $field.html(value);
              break;
            default:
              $field.attr("value", value);
              break;
          }
        }

        if (field.type === 'editable') {
          tinymce.init({
            selector: '#' + key,
            theme: 'inlite',
            plugins: 'image advlist samlink paste contextmenu textpattern autolink moxiemanager acecode',
            insert_toolbar: 'image | bullist numlist',
            selection_toolbar: 'bold italic removeformat | samlink',
            contextmenu: 'acecode',
            inline: true,
            paste_data_images: true
          });
        }
      });

      $AM("#pageid").attr("value", $AM.SAM.page.id);
    };

    $AM.FDOs.editContactInfo = {
      destination: "default.asp",
      method: "POST",
      title: "Edit Contact Info",
      class: "SAMtwoColumn",
      init: function populateContactInfo() {
        var $drawer = $AM("#SAMdrawer");

        populateEntityData(this.fields);
      },
      fields: {
        ContactEmail: {
          type: "email",
          name: "email",
          label: "Main Contact Email",
          column: "left",
          value: ""
        },
        ContactPhoneNumber: {
          type: "phone",
          name: "telephone",
          label: "Main Contact Phone Number",
          column: "right",
          value: ""
        },
        entityType: { type: "hidden", value: "Contact Info", column: "bottom" },
        action: { type: "hidden", value: "editPageData", column: "bottom" },
        pageid: { type: "hidden", value: 0, column: "bottom" }
      }
    }

    $AM.FDOs.editSolution = {
      destination: "default.asp",
      method: "POST",
      title: "Edit Solution",
      class: "SAMtwoColumn",
      init: function populateSolution() {
        var $drawer = $AM("#SAMdrawer");

        populateEntityData(this.fields);
      },
      fields: {
        entityType: { type: "hidden", value: "Solution", column: "bottom" },
        action: { type: "hidden", value: "editPageData", column: "bottom" },
        pageid: { type: "hidden", value: 0, column: "bottom" }
      }
    }

    $AM.FDOs.editProduct = {
      destination: "default.asp",
      method: "POST",
      title: "Edit Product",
      class: "SAMtwoColumn",
      init: function populateProduct() {
        var $drawer = $AM("#SAMdrawer");

        populateEntityData(this.fields);
      },
      fields: {
        entityType: { type: "hidden", value: "Product", column: "bottom" },
        action: { type: "hidden", value: "editPageData", column: "bottom" },
        pageid: { type: "hidden", value: 0, column: "bottom" }
      }
    }
  });
});

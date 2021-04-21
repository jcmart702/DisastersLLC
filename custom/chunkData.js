var populateChunkData;
var chunkTypes = ['Person', 'Form', 'Place'];

$AM.SAM.metadata.ChunkTypes = chunkTypes;

populateChunkData = function(fields) {
  var chunk;

  $AM.each($AM.SAM.page.chunk, function eachChunk(idx, obj) {
    if (obj.id === fields.chunkid.value) {
      chunk = obj;
    }
  });

  $AM.each(fields, function eachField(key, val) {
    var $field = $AM("#" + key);
    var name = val.name || key;
    if (chunk.chunkData && chunk.chunkData[name]) {
      $AM("#" + key);
      switch (val.type) {
        case "text":
        case "number":
        case "email":
        case "phone":
        case "password":
        case "url":
        case "datetime-local":
        case "date":
        case "time":
        case "week":
        case "month":
        case "filepicker":
        case "pagepicker":
          $field.attr("value", chunk.chunkData[name]);
          break;
        case "select":
          $field.find("option[value=\"" + chunk.chunkData[name] + "\"]").prop("selected", true);
          break;
        case "textarea":
          $field.text(chunk.chunkData[name]);
          break;
        case "checkbox":
          $field.prop("checked", chunk.chunkData[name]);
          break;
        case "editable":
          $field.html(chunk.chunkData[name]);
          break;
      }
    }

    if (val.type === 'editable') {
//      Inject a sibling input to store the path of the CSS files associated with this page.
// 			.before('<input type="hidden" id="css" value="' + cssPath + '" />');
      tinymce.init({
        selector: '#' + key,
        theme: 'inlite',
        plugins: 'image advlist samlink paste contextmenu textpattern autolink moxiemanager acecode',
        insert_toolbar: 'image | bullist numlist',
        selection_toolbar: 'bold italic removeformat | samlink',
        contextmenu: 'acecode',
        inline: true,
        paste_data_images: true,
//           content_css: [
//             '//fonts.googleapis.com/css?family=Lato:300,300i,400,400i',
//             '//www.tinymce.com/css/codepen.min.css'
//           ]
      });
    }
  });

  $AM('#pageid').attr('value', $AM.SAM.page.id);

  return chunk;
};

$AM.FDOs.editPerson = {
  myKey: "editPerson",
  destination: "default.asp",
  method: "POST",
  title: "Edit Person",
  class: "SAMtwoColumn",
  init: function popPersonData() {
    populateChunkData(this.fields);
    this.preview();
  },
  fields: {
    Name: {
      type: "text",
      label: "Person Name",
      tooltip: "Full name of the person.",
      column: "left",
      value: "",
      autofocus: true
    },
    Position: {
      type: "text",
      label: "Position / Title",
      tooltip: "Job title of this person.",
      column: "left",
      value: ""
    },
    Photo: {
      type: "filepicker",
      label: "Portrait Photo",
      column: "left",
      value: ""
    },
    Email: {
      type: "text",
      label: "Email",
      tooltip: "Email Address for this person",
      column: "left",
      value: ""
    },
    Linkedin: {
      type: "text",
      label: "Linkedin",
      tooltip: "Linkedin URL for this person",
      column: "left",
      value: ""
    },
    AltText: {
      type: "text",
      label: "Alternate Text",
      column: "bottom",
      style: "clear:both",
      value: ""
    },
    entityType: { type: "hidden", value: "Person", column: "bottom" },
    action: { type: "hidden", value: "editChunkData", column: "bottom" },
    chunkid: { type: "hidden", value: 0, column: "bottom" }
  },
  preview: function previewImage() {
    var $fp = $AM("input#Photo");
    var img = $fp.val();
    var $parent = $("#SAMdrawerLiveArearight");
    console.log($parent);
    $parent.empty().css("text-align", "right");
    $parent.append("<img src=\"" + img + "\" class=\"flex-width\" />");
  },
  events: {
    "change [id='Photo']": "preview"
  }
};

$AM.FDOs.editForm = {
  destination: 'default.asp',
  method: 'POST',
  title: 'Form Builder',
  init: function initFormEditor() {
    var fdo = this;
    var $drawer = fdo.$drawer = $AM('#SAMdrawer');
    var $fieldContainer = fdo.$fieldContainer = $AM('#FormFields .fields', $drawer);
    var $buttonContainer = fdo.$buttonContainer = $AM('#FormFields .buttons', $drawer);

    $AM('#SAMdrawerLiveAreabottom').css('overflow', 'auto');

    var chunk = populateChunkData(this.fields);
    var chunkData = chunk.chunkData || {};

    var nonFieldKeys = ['entityType', 'action-attribute', 'method-attribute', 'submit', 'cancel'];

    var fields = [];

    $AM.each(chunkData, function eachDatum(key, value) {
      if (nonFieldKeys.indexOf(key) === -1) {
        var data = {};
        value.split('|').forEach(function(props) {
          var prop = props.split(':');
          data[prop[0]] = prop[1];
        });
        data.name = key;
        data.configs = value;

        fields.push(data);

      } else {
        $AM('[name="' + key + '"]', $buttonContainer).val(value);
      }
    });

    // Sort the fields by the index key.
    fields.sort(function(a, b) {
      return a.index - b.index;
    });

    fields.forEach(function(data) {
      var fieldHtml = fdo.template(data);
      $fieldContainer.append('<tr>' + fieldHtml + '</tr>');
    });

    $fieldContainer.append('<tr class="placeholder">' + fdo.template() + '</tr>');

    $fieldContainer.sortable({
      axis: 'y',
      handle: '.sort-handle',
      placeholder: 'highlight',
      update: function( e, ui) {
        $fieldContainer.children().each(function(index) {
          var $field = $AM(this);
          $field.find('[data-name="index"]').val(index + 1).change();
        });
      }
    });
  },
  template: function(data) {
    if (!data) data = {};
    return [
      '<td class="sort-handle">≡ <input data-name="index" type="hidden" value="' + data.index + '" /></td>',
      '<td><input data-name="label" type="text" placeholder="Label"' + (data.label? ' value="' + data.label + '"' : '') + '/></td>',
      '<td><input data-name="name" type="text" placeholder="Name"' + (data.name? ' value="' + data.name + '"' : '') + '/></td>',
      '<td><input data-name="value" type="text" placeholder="Default value"' + (data.value? ' value="' + data.value + '"' : '') + '/></td>',
      '<td><select data-name="type">',
        this.types.map(function(type) {
          var value = type.value, name = type.name;
          var selected = data.type === value;
          return '<option value="' + value + '"'+ (selected ? ' selected' : '') + '>' + name + '</option>';
        }).join(''),
      '</select></td>',
      '<td>',
        '<input data-name="options" type="text" value="' + (data.options || '') + '" />',
        '<input type="hidden" name="' + (data.name || '') + '" value="' + (data.configs || '') + '" />',
      '</td>',
      '<td>',
        '<input data-name="required" type="checkbox"' + (data.required? ' checked' : '') + '/>',
      '</td>',
    ].join('');
  },
  onchange: function handleInputChange(event) {
    var $field = $AM(event.target).closest('tr');
    var $props = $field.find('[data-name]');
    var $name = $field.find('[name]');
    $field.find('[data-name="index"]').val($field.index() + 1);

    var configs = [];
    $props.each(function() {
      var $input = $AM(this);
      var name = $input.attr('data-name');
      var type = $input.attr('type');
      var value = type === 'checkbox'? ($input[0].checked? 1 : 0) : $input.val();
      if (name === 'name') {
        $name.attr('name', value);
      }
      if (value) {
        configs.push(name + ':' + value);
      }
    });

    var value = configs.join('|');
    if (/index:[\d]+\|type:text$/.test(value)) {
      // All other fields are cleared.
      value = '';
    }
    $name.val(value);

    if (value) {
      $field.removeClass('placeholder');
    } else {
      $field.toggleClass('placeholder', true);
    }

    if (!this.$drawer.find('.placeholder').length) {
      this.$fieldContainer.append('<tr class="placeholder">' + this.template() + '</tr>');
    }
  },
  types: [{
    name: 'Text',
    value: 'text'
  }, {
    name: 'Number',
    value: 'number'
  }, {
    name: 'Email',
    value: 'email'
  }, {
    name: 'Password',
    value: 'password'
  }, {
    name: 'URL',
    value: 'url'
  }, {
    name: 'Phone number',
    value: 'phone'
  }, {
    name: 'Date time',
    value: 'datetime-local'
  }, {
    name: 'Date',
    value: 'date'
  }, {
    name: 'Month',
    value: 'month'
  }, {
    name: 'Time',
    value: 'time'
  }, {
    name: 'Week',
    value: 'week'
  }, {
    name: 'Textarea',
    value: 'textarea'
  }, {
    name: 'Select box',
    value: 'select'
  }, {
    name: 'Checkbox',
    value: 'checkbox'
  }, {
    name: 'Radio box',
    value: 'radio'
  }, {
    name: "File",
    value: "file"
  },  {
    name: "Color",
    value: "color"
  }, {
    name: 'Hidden',
    value: 'hidden'
  }, {
    name: 'Honeypot',
    value: 'honeypot'
  }],
  fields: {
    FormTarget: {
      type: "pagepicker",
      name: 'action-attribute',
      label: 'Form Target',
      tooltip: 'Where to submit the form to.',
      column: 'left',
      value: ''
    },
    FormMethod: {
      type: 'select',
      name: 'method-attribute',
      label: 'Form method',
      tooltip: 'The method to submit the form.',
      column: 'right',
      options: [
        {
          'label': 'POST',
          'value': 'POST'
        },
        {
          'label': 'GET',
          'value': 'GET'
        }
      ],
      style: 'margin-top: 22px;'
    },
    FormFields: {
      type: 'div',
      label: 'Form fields',
      column: 'bottom',
      value: [
        '<table style="width:100%;">',
          '<thead>',
            '<tr>',
              '<th />',
              '<th>Label</th>',
              '<th>Name</th>',
              '<th>Value</th>',
              '<th>Type</th>',
              '<th>Options</th>',
              '<th>Req?</th>',
            '</tr>',
          '</thead>',
          '<tbody class="fields" />',
          '<tfoot class="buttons">',
            '<tr>',
              '<th colspan="3" />',
              '<th colspan="1">Cancel button</th>',
              '<th colspan="2">Submit button</th>',
            '</tr>',
            '<tr>',
              '<td colspan="3" />',
              '<td colspan="1"><input name="cancel" placeholder="Cancel" /></td>',
              '<td colspan="2"><input name="submit" placeholder="Submit" value="Submit" /></td>',
            '</tr>',
          '</tfoot>',
        '</table>'
      ].join(''),
      style: 'margin-top: 22px;'
    },
    entityType: { type: 'hidden', value: 'Form', column: 'bottom' },
    action: { type: 'hidden', value: 'editChunkData', column: 'bottom' },
    chunkid: { type: 'hidden', value: 0, column: 'bottom' }
  },
  events: {
    'change #FormFields .fields :input': 'onchange'
  }
}

$AM.FDOs.editPlace = {
  destination: "default.asp",
  method: "POST",
  title: "Edit Location",
  class: "SAMtwoColumn",
  init: function popPlaceData() {
    populateChunkData(this.fields);
    this.preview();
  },
  preview: function previewMap() {
    var $drawer = $AM("#SAMdrawer");
    var $preview = $drawer.find("#PlacePreview");

    var address = $AM("#PlaceStreetAddress", $drawer).val();
    address += ", " + $AM("#PlaceAddressLocality", $drawer).val();
    address += ", " + $AM("#PlaceAddressRegion", $drawer).val();
    address += " " + $AM("#PlacePostalCode", $drawer).val();
    var url = "//www.google.com/maps/embed/v1/place?q=" + address;
    url += "&key=AIzaSyCPVhgCrbKphv-w7237f12b3huFVJTg21w";

    var $iframe = $preview.find("iframe");
    if (!$iframe.length) {
      $iframe = $AM("<iframe width=\"390\" height=\"300\" frameborder=\"0\" style=\"border:0\" />");
      $iframe.appendTo($preview);
    }
    $iframe.attr("src", url);
    $iframe.attr("title", "Google Maps at " + address);
  },
  events: {
    "change [id^='Place']": "preview"
  },
  fields: {
    PlaceName: {
      type: "text",
      name: "name",
      label: "Name",
      column: "left",
      value: "",
      autofocus: true
    },
    PlaceStreetAddress: {
      type: "text",
      name: "address.streetAddress",
      label: "Street Address",
      column: "left",
      value: ""
    },
    PlaceStreetAddress2: {
      type: "text",
      name: "address.streetAddress2",
      label: "Street Address 2",
      column: "left",
      value: ""
    },
    PlaceAddressLocality: {
      type: "text",
      name: "address.addressLocality",
      label: "City",
      column: "left",
      value: ""
    },
    PlaceAddressRegion: {
      type: "text",
      name: "address.addressRegion",
      label: "State",
      column: "left",
      value: ""
    },
    PlacePostalCode: {
      type: "text",
      name: "address.postalCode",
      label: "Zipcode",
      column: "left",
      value: ""
    },
    PlaceTelephone: {
      type: "phone",
      name: "telephone",
      label: "Phone number",
      column: "left",
      value: ""
    },
    PlacePreview: {
      type: "div",
      label: "Preview",
      column: "right",
      value: ""
    },
    entityType: { type: "hidden", value: "Place", column: "bottom" },
    action: { type: "hidden", value: "editChunkData", column: "bottom" },
    chunkid: { type: "hidden", value: 0, column: "bottom" }
  }
}

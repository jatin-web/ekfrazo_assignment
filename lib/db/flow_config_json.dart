Map<String, dynamic> flowConfigJson = {
  "name": "STOCK_REPORTS",
  "active": true,
  "initialPage": "infoScreen",
  "flows": [
    {
      "name": "infoScreen",
      "screenType": "TEMPLATE",
      "heading": "INSTRUCTIONS",
      "body": [
        {
          "type": "template",
          "format": "card",
          "children": [
            {
              "type": "template",
              "format": "text",
              "data": [
                {
                  "key": "WELCOME",
                  "value":
                      "Welcome to Stock Report Form. Fill all required fields: 1. Medicine Details 2. Report Type 3. Quantity Details 4. Entry Person",
                },
              ],
            },
          ],
        },
      ],
      "footer": [
        {
          "type": "template",
          "format": "button",
          "label": "START FORM",
          "onAction": [
            {
              "actionType": "NAVIGATION",
              "properties": {"name": "stockForm", "type": "FORM"},
            },
          ],
        },
      ],
    },
    {
      "name": "stockForm",
      "screenType": "FORM",
      "heading": "STOCK REPORT",
      "pages": [
        {
          "page": "medicineDetails",
          "label": "MEDICINE DETAILS",
          "order": 1,
          "actionLabel": "NEXT",
          "properties": [
            {
              "type": "template",
              "format": "textInput",
              "fieldName": "medicine",
              "label": "MEDICINE NAME",
              "mandatory": true,
              "validations": [
                {"type": "required", "message": "MEDICINE_REQUIRED"},
                {"type": "minLength", "value": 2, "message": "MIN_2_CHARS"},
              ],
            },
          ],
        },
        {
          "page": "reportType",
          "label": "REPORT TYPE",
          "order": 2,
          "actionLabel": "NEXT",
          "properties": [
            {
              "type": "template",
              "format": "dropdown",
              "fieldName": "type",
              "label": "TYPE",
              "mandatory": true,
              "enums": [
                {"code": "IN", "name": "Stock In"},
                {"code": "OUT", "name": "Stock Out"},
              ],
              "validations": [
                {"type": "required", "message": "TYPE_REQUIRED"},
              ],
            },
          ],
        },
      ],
      "onSubmit": [
        {
          "actionType": "SHOW_TOAST",
          "properties": {"message": "Captured: {{medicine}} - {{type}}"},
        },
        {
          "actionType": "NAVIGATION",
          "properties": {"name": "quantityForm", "type": "FORM"},
        },
      ],
    },
    {
      "name": "quantityForm",
      "screenType": "FORM",
      "heading": "QUANTITY DETAILS",
      "pages": [
        {
          "page": "quantityDetails",
          "label": "QUANTITY DETAILS",
          "order": 1,
          "actionLabel": "NEXT",
          "properties": [
            {
              "type": "template",
              "format": "textInput",
              "fieldName": "quantity",
              "label": "QUANTITY",
              "mandatory": true,
              "validations": [
                {"type": "required", "message": "QUANTITY_REQUIRED"},
                {"type": "minLength", "value": 1, "message": "MIN_1_CHAR"},
              ],
            },
            {
              "type": "template",
              "format": "dropdown",
              "fieldName": "unit",
              "label": "UNIT",
              "mandatory": true,
              "enums": [
                {"code": "PCS", "name": "Pieces"},
                {"code": "BOX", "name": "Boxes"},
                {"code": "KG", "name": "Kilograms"},
              ],
              "validations": [
                {"type": "required", "message": "UNIT_REQUIRED"},
              ],
            },
          ],
        },
      ],
      "onSubmit": [
        {
          "actionType": "NAVIGATION",
          "properties": {"name": "capturedPreview", "type": "TEMPLATE"},
        },
      ],
    },
    {
      "name": "capturedPreview",
      "screenType": "TEMPLATE",
      "heading": "CAPTURED DETAILS",
      "body": [
        {
          "type": "template",
          "format": "card",
          "children": [
            {
              "type": "template",
              "format": "labelPairList",
              "data": [
                {"key": "MEDICINE", "value": "{{medicine}}"},
                {"key": "TYPE", "value": "{{type}}"},
                {"key": "QUANTITY", "value": "{{quantity}} {{unit}}"},
              ],
            },
          ],
        },
      ],
      "footer": [
        {
          "type": "template",
          "format": "button",
          "label": "PROCEED TO ENTRY DETAILS",
          "onAction": [
            {
              "actionType": "NAVIGATION",
              "properties": {"name": "entryPersonForm", "type": "FORM"},
            },
          ],
        },
      ],
    },
    {
      "name": "entryPersonForm",
      "screenType": "FORM",
      "heading": "ENTRY DETAILS",
      "pages": [
        {
          "page": "entryPerson",
          "label": "ENTRY PERSON",
          "order": 1,
          "actionLabel": "SUBMIT",
          "properties": [
            {
              "type": "template",
              "format": "textInput",
              "fieldName": "entryPerson",
              "label": "ENTRY PERSON NAME",
              "mandatory": true,
              "validations": [
                {"type": "required", "message": "ENTRY_PERSON_REQUIRED"},
                {"type": "minLength", "value": 2, "message": "MIN_2_CHARS"},
              ],
            },
          ],
        },
      ],
      "onSubmit": [
        {
          "actionType": "NAVIGATION",
          "properties": {"name": "finalSuccessScreen", "type": "TEMPLATE"},
        },
      ],
    },
    {
      "name": "finalSuccessScreen",
      "screenType": "TEMPLATE",
      "heading": "SUCCESS",
      "body": [
        {
          "type": "template",
          "format": "card",
          "children": [
            {
              "type": "template",
              "format": "labelPairList",
              "data": [
                {"key": "MEDICINE", "value": "{{medicine}}"},
                {"key": "TYPE", "value": "{{type}}"},
                {"key": "QUANTITY", "value": "{{quantity}} {{unit}}"},
                {"key": "ENTRY PERSON", "value": "{{entryPerson}}"},
              ],
            },
          ],
        },
      ],
      "footer": [
        {
          "type": "template",
          "format": "button",
          "label": "BACK TO FORM",
          "onAction": [
            {
              "actionType": "NAVIGATION",
              "properties": {"name": "stockForm", "type": "FORM"},
            },
          ],
        },
      ],
    },
  ],
};

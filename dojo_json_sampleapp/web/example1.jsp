<html>
<body onLoad="onLoad();">
<head>
 <title>Example 1</title>
 <script language="javascript" src="js/dojo/dojo.js"></script>
 <script language="javascript">
  dojo.require("dojo.io.*");
  dojo.require("dojo.event.*");

  function onLoad() {
   var buttonObj = document.getElementById("myButton");
   dojo.event.connect(buttonObj, "onclick", this, "onclick_myButton");
  }

  function onclick_myButton() {
   var bindArgs = {
    url: "actions/welcome.jsp",
    error: function(type, data, evt){
     alert(data);
    },
    load: function(type, data, evt){
     alert(data);
    },
    mimetype: "text/plain",
    formNode: document.getElementById("myForm")
   };
   dojo.io.bind(bindArgs);
  }
 </script>
</head>
<body>
<form id="myForm">
<h1>Enter Name</h1>
<p>
Please enter a name:
</p>
 <input type="text" name="name"/>
 <input type="button" id="myButton" value="Submit"/>
</form>
</body>
</html>


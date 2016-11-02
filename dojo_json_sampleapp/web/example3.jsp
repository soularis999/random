<html>
<body>
<head>
<title>Example 3</title>
<script language="javascript" src="js/dojo/dojo.js"></script>
<script type="text/javascript">
    dojo.hostenv.setModulePrefix('utils', 'utils');
    dojo.widget.manager.registerWidgetPackage('utils');
    dojo.require("utils.AutoComplete");
</script>

<style type="text/css">
.choices {
    background-color: lavender;
    color: black;
    border: solid #000000;
    border-width: 0px 1px 1px 1px;
    font: 10px arial;
    display: none;
    position: absolute;

}

.selected {
    background-color: #222222;
    color: white;
    border: solid #CCCCCC;
    border-width: 0px 1px 1px 1px;
    font: 10px arial;
    width: 100%;
}
</style>
</head>
<body>
<h1>Enter Author</h1>
<p>
Start typing the last name of an author:
</p>
<form id="authorForm">
<input type="text" style="width: 300px" name="author" id="author"/><input type="button" value="Enter" onclick="alert('Pretend this does something useful');"/>
<dojo:AutoComplete formId="authorForm"
		   textboxId="author"
		   action="actions/authors.jsp"/>


</form>
</body>
</html>


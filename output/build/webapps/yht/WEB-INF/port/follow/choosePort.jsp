<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" type="text/css" href="${path }/css/buttonPanel.css">
		<title>选择患者</title>
		<script type="text/javascript">
			var table;
			$(document).ready(function(){
				table = $('#dataTable').datagrid({
					url:'${path}/port/follow!portList.qt?type=list&chkAccess='+encodeURIComponent('${param.chkAccess}'),
					width:document.body.clientWidth,
					height:document.body.clientHeight-$('.buttonPanel').height()-9,
					idField:'id',
					pagination:true,
					nowrap:true,
					border:false,
					striped:true,
					fitColumns:true,
					rownumbers:true,
					clickSingleSelect:true,
					columns:[[
						{field:'check',width:10,align:'center',checkbox:'true'},
						{field:'name',width:20,align:'center',title:'姓名'},
						{field:'sex',width:20,align:'center',title:'性别'},
						{field:'homeTel',width:20,align:'center',title:'手机号'},
						{field:'disDate',width:20,align:'center',title:'出院时间'}
					]],
					onHeaderContextMenu: function(e, field){
						e.preventDefault();
						if (!$('#tmenu').length){
							createColumnMenu(table);
						}
						$('#tmenu').menu('show', {
							left:e.pageX,
							top:e.pageY
						});
					}
				});
			});
			function query(){
				table.datagrid('options').queryParams = {'txtSearch':$('#txtSearch').val(),'inStart':$('#inStart').val(),'inEnd':$('#inEnd').val(),'outStart':$('#outStart').val(),'outEnd':$('#outEnd').val()};
				table.datagrid('reload');
				table.datagrid('clearSelections');
			}
			function fixedChoose(){
				var win = parent.win;
				var rows = table.datagrid('getSelections');
				if(rows&&0==rows.length)parent.jQuery.messager.alert('错误','对不起！请至少选择一条记录！','error');
				else if(win!=''){
					if(win&&win.refreshParent){
						var mobiles='';
						var rowlen=rows.length;
						for(var i=0;i<rowlen;i++){
							if(parent.choosePerson){
								var temp = parent.choosePerson(rows[i]);
								if(temp&&temp!='') mobiles+=','+temp;
							}else if(mobiles.indexOf(rows[i].homeTel)==-1)
								mobiles+=','+rows[i].homeTel;
						}
						if(mobiles.length>1&&mobiles.indexOf(',')==0){
							mobiles=mobiles.substring(1);
							win.refreshParent(mobiles);
						}
					}
				}
			}
			function fixedChooseAll(){
				var win = parent.win;
				var params = '&txtSearch='+encodeURIComponent($('#txtSearch').val());
				if(win!=''){
					if(win&&win.refreshParent){
						jQuery.ajax({
							async: false,
							type: "GET",
							url: '${path}/port/follow!portList.qt?type=all&chkAccess='+encodeURIComponent('${param.chkAccess}')+params,
							success: function(mobiles){
								win.refreshParent(mobiles);
							}
						});
					}
				}
			}
		</script>
	</head>
	<body>
		<div class="buttonPanel">
			<a onclick="fixedChoose()" class="easyui-linkbutton" plain="false" iconCls="icon-ok" style="margin-right:10px">提交选择数据</a>
			<a onclick="fixedChooseAll()" class="easyui-linkbutton" plain="false" iconCls="icon-ok" style="margin-right:10px">提交查询数据</a>
			<div class="datagrid-btn-separator"></div>
			<a href="javascript:query()" class="easyui-linkbutton" plain="false" iconCls="icon-search" style="margin-right:10px">查询</a>
			<input type="text" id="txtSearch" name="txtSearch" title="请输入要查询的关键字" style="float:left;margin-top:2px;margin-right:10px"/>
			<label for="start" style="text-align: right;width: 203px">出院时间：</label>
				<input type="text" name="outStart" id="outStart" style="" class="easyui-validatebox" methodType="chooseDate{dateFmt:'yyyy-MM-dd '}"/>
				<input type="text" name="outEnd" id="outEnd" style="" class="easyui-validatebox" methodType="chooseDate{dateFmt:'yyyy-MM-dd '}"/>
			<div class="clear"></div>
		</div>
		<table id="dataTable"></table>
	</body>
</html>
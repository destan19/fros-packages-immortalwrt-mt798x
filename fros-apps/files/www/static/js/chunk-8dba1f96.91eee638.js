(window["webpackJsonp"]=window["webpackJsonp"]||[]).push([["chunk-8dba1f96"],{"21d1":function(t,e,n){"use strict";n.r(e);var o=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("div",{staticClass:"app-container"},[n("div",{staticStyle:{"margin-left":"20px","margin-top":"20px","font-size":"14px"}},[t._v(" 恢复出厂设置")]),n("el-form",{ref:"form",staticStyle:{"margin-top":"30px"},attrs:{model:t.form,"label-width":"20%",size:"small"}},[n("el-form-item",[n("el-button",{staticStyle:{width:"300px"},attrs:{type:"primary"},on:{click:t.onSubmit}},[t._v("立即恢复")])],1)],1),n("div",{staticStyle:{"margin-left":"20px","margin-top":"20px","font-size":"14px"}},[t._v(" 固件升级")]),n("el-form",{ref:"form",staticStyle:{"margin-top":"30px"},attrs:{model:t.form,"label-width":"20%",size:"small"}},[n("el-form-item",[n("el-button",{staticStyle:{width:"300px"},attrs:{type:"primary"},on:{click:t.menualUpgradeHandle}},[t._v("选择固件升级")])],1)],1),n("el-dialog",{attrs:{title:t.diaglogTitle,visible:t.dialogFormVisible,width:"50%",modal:"","show-close":!1,"close-on-click-modal":!1},on:{"update:visible":function(e){t.dialogFormVisible=e}}},[n("div",[t._v(t._s(t.tips))]),n("br"),n("el-progress",{attrs:{percentage:t.percent,"stroke-width":3,color:"#8e71c7"}}),n("br")],1),n("el-dialog",{attrs:{title:"固件升级","show-close":!1,"close-on-click-modal":!1,"close-on-press-escape":!1,visible:t.upgradeDialogFormVisible,width:"700px"},on:{"update:visible":function(e){t.upgradeDialogFormVisible=e}}},[n("div",{attrs:{id:"upload"}},[n("el-upload",{ref:"upload",staticClass:"upload-demo",attrs:{name:"upload_bin",drag:"","file-list":t.fileList,"on-success":t.handleUploadSuccess,"on-remove":t.handleRemoveFile,"before-upload":t.beforeUploadHandle,limit:1,action:"/cgi-bin/fros/upload_bin"}},[n("i",{staticClass:"el-icon-upload"}),n("div",{staticClass:"el-upload__text"},[t._v(" 将升级固件拖到此处，或"),n("em",[t._v("点击上传固件")])])])],1),n("div",{attrs:{id:"save"}},[t._v(" 保留配置: "),n("el-switch",{model:{value:t.save_config,callback:function(e){t.save_config=e},expression:"save_config"}})],1),n("span",{staticClass:"dialog-footer",attrs:{slot:"footer"},slot:"footer"},[n("el-button",{on:{click:function(e){return t.cancelUpgradeHadle()}}},[t._v("取 消")]),n("el-button",{attrs:{type:"primary",disabled:t.no_file},on:{click:function(e){return t.upgradeHandle()}}},[t._v(" 开始升级 ")])],1)])],1)},a=[],i=n("8593"),r={data:function(){return{dialogStatus:"",diaglogTitle:"",dialogFormVisible:!1,tips:"配置已恢复，设备正在重启，请稍后...",percent:0,file_num:0,no_file:!0,fileList:[],form:{},heart_status:0,upgradeDialogFormVisible:!1,save_config:!0}},created:function(){this.fetchData()},methods:{fetchData:function(){},successHandle:function(){},cancelUpgradeHadle:function(){var t={data:{}};this.$refs.upload.clearFiles(),this.upgradeDialogFormVisible=!1,Object(i["a"])(t).then((function(t){})),this.no_file=!0},beforeUploadHandle:function(t){return!0},upgradeHandle:function(){var t=this;this.upgradeDialogFormVisible=!1,this.tips="系统正在升级，请不要断电...",this.dialogFormVisible=!0;var e={data:{}};e.data.save_config=this.save_config,Object(i["s"])(e).then((function(t){}));var n=setInterval((function(){t.heart_status>5?t.percent+=10:t.percent++,Object(i["j"])().then((function(e){t.heart_status++})),console.log("check count "+t.heart_status),t.percent>=100&&(clearInterval(n),t.dialogFormVisible=!1,t.percent=0)}),2e3)},handleRemoveFile:function(){var t={data:{}};this.$refs.upload.clearFiles(),Object(i["a"])(t).then((function(t){})),this.no_file=!0},menualUpgradeHandle:function(){this.save_config=!0,this.upgradeDialogFormVisible=!0},handleUploadSuccess:function(t,e,n){console.log("upload success response data = "+t),2e4!=t.code?(this.$refs.upload.clearFiles(),console.log("image error"),this.$notify({message:"固件格式错误!",type:"error",duration:5e3}),this.no_file=!0):(console.log("upload success."),this.no_file=!1,this.$notify({message:"上传成功!",type:"success",duration:2e3}))},onSubmit:function(){var t=this;this.$confirm("确定恢复出厂设置吗?部分设备恢复出厂设置后设备id会改变，请做好lan口mac和注册码备份","提示",{confirmButtonText:"确定",cancelButtonText:"取消",type:"warning"}).then((function(){var e={data:{}};t.dialogFormVisible=!0,Object(i["l"])(e).then((function(t){}));var n=setInterval((function(){t.percent++,t.percent>=100&&(clearInterval(n),t.dialogFormVisible=!1,t.percent=0)}),1e3)})).catch((function(){}))}}},c=r,l=(n("8a9a"),n("7015"),n("2877")),s=Object(l["a"])(c,o,a,!1,null,"1689b3b9",null);e["default"]=s.exports},"3cf8":function(t,e,n){},5710:function(t,e,n){},7015:function(t,e,n){"use strict";n("5710")},8593:function(t,e,n){"use strict";n.d(e,"e",(function(){return a})),n.d(e,"m",(function(){return i})),n.d(e,"h",(function(){return r})),n.d(e,"f",(function(){return c})),n.d(e,"g",(function(){return l})),n.d(e,"i",(function(){return s})),n.d(e,"j",(function(){return u})),n.d(e,"o",(function(){return d})),n.d(e,"q",(function(){return f})),n.d(e,"n",(function(){return p})),n.d(e,"r",(function(){return m})),n.d(e,"p",(function(){return b})),n.d(e,"k",(function(){return g})),n.d(e,"a",(function(){return h})),n.d(e,"s",(function(){return _})),n.d(e,"l",(function(){return v})),n.d(e,"b",(function(){return j})),n.d(e,"d",(function(){return O})),n.d(e,"c",(function(){return y}));var o=n("b775");function a(t){return Object(o["a"])({url:"/get_account_info",method:"get",params:t})}function i(t){return Object(o["a"])({url:"/set_account_info",method:"post",data:t})}function r(t){return Object(o["a"])({url:"/get_license",method:"get",params:t})}function c(t){return Object(o["a"])({url:"/get_bind_info",method:"get",params:t})}function l(t){return Object(o["a"])({url:"/get_cloud",method:"get",params:t})}function s(t){return Object(o["a"])({url:"/get_reboot_info",method:"get",params:t})}function u(t){return Object(o["a"])({url:"/heart",method:"get",params:t})}function d(t){return Object(o["a"])({url:"/set_cloud",method:"post",data:t})}function f(t){return Object(o["a"])({url:"/set_reboot_info",method:"post",data:t})}function p(t){return Object(o["a"])({url:"/set_bind_info",method:"post",data:t})}function m(t){return Object(o["a"])({url:"/unbind_cloud",method:"post",data:t})}function b(t){return Object(o["a"])({url:"/set_license",method:"post",data:t})}function g(t){return Object(o["a"])({url:"/reboot_system",method:"post",data:t})}function h(t){return Object(o["a"])({url:"/cancel_upgrade",method:"post",data:t})}function _(t){return Object(o["a"])({url:"/upgrade",method:"post",data:t})}function v(t){return Object(o["a"])({url:"/reset_system_config",method:"post",data:t})}function j(t){return Object(o["a"])({url:"/cmd_clean_all_dev",method:"post",data:t})}function O(t){return Object(o["a"])({url:"/cmd_clean_offline_dev",method:"post",data:t})}function y(t){return Object(o["a"])({url:"/cmd_clean_all_visit",method:"post",data:t})}},"8a9a":function(t,e,n){"use strict";n("3cf8")}}]);
local ds = require "luci.dispatcher"
local nxo = require "nixio"
local nfs = require "nixio.fs"
local ipc = require "luci.ip"
local sys = require "luci.sys"
local utl = require "luci.util"
local dsp = require "luci.dispatcher"
local uci = require "luci.model.uci"
local lng = require "luci.i18n"
local jsc = require "luci.jsonc"
local http = luci.http
local SYS = require "luci.sys"
local m, s

m = Map("fros_ipk", translate("FROS系统"),
    translate("FROS是一款基于OpenWrt的行为管理系统，包含应用过滤、网址过滤、端口过滤、上网审计等功能，采用独立的配置管理界面，使用前请先通过该界面安装。"))


s = m:section(TypedSection, "global", translate("系统状态"),
"<font color='red'>" ..
    translate("") ..
    "</font>")
s.anonymous = true
s:append(Template("fros"))


-- s = m:section(TypedSection, "ipk", translate("本地安装"), "")

-- fu = s:option(FileUpload, "")
-- fu.template = "cbi/ipk_upload"
-- s.anonymous = true

-- um = s:option(DummyValue, "rule_data")
-- um.template = "cbi/dvalue"
-- um.rawhtml = true


local dir, fd
dir = "/tmp/upload/"
nixio.fs.mkdir(dir)
http.setfilehandler(function(meta, chunk, eof)
    if not fd then
        if not meta then
            return
        end
        if meta and chunk then
            fd = nixio.open(dir .. meta.file, "w")
        end
        if not fd then
            return
        end
    end
    if chunk and fd then
        fd:write(chunk)
    end
    if eof and fd then
        fd:close()
		os.execute("echo ''>/tmp/log/fros_install.log")
        local ret=os.execute("fros_mgr install /tmp/upload/"..meta.file..">/dev/null");
	
    	local fd2 = io.open("/tmp/log/fros_install.log")
		local log_str=""
        if fd2 then
            local line
            while true do
                line = fd2:read("*l")
     		if not line then
                    break
                end
		log_str=log_str.."</br>"..line
	    end
	   fd2:close()
	end	
    if ret == 0 then                                                                                            
		log_str=log_str.."</br><b style='color:green'>install ok</b>"                                       
	else                                                                                                        
		log_str=log_str.."</br><b style='color:red'>install failed</b>"                                     
	end  
	um.value=log_str
    end
end)

if luci.http.formvalue("upload") then
    local f = luci.http.formvalue("ulfile")
    if #f <= 0 then
        -- um.value = translate("No specify upload file.")
    end
elseif luci.http.formvalue("download") then
    Download()
end
return m

local http = require "luci.http"
local fs = require "nixio.fs"
local sys = require "luci.sys"
local uci = require"luci.model.uci".cursor()
local util = require "luci.util"
local datatypes = require "luci.cbi.datatypes"
local i18n = require "luci.i18n"

curl = "/usr/bin/curl"
curl_args = {"-skL", "--connect-timeout 3", "--retry 1", "-m 60"}
wget = "/usr/bin/wget"
wget_args = {"--no-check-certificate", "--quiet", "--timeout=100", "--tries=3"}
local fros_api = "http://feature.ifros.cn:8081/fros/get_ipk_info"
module("luci.controller.fros", package.seeall)
function index()
	entry({"admin", "system", "fros"}, cbi("fros", {hideapplybtn=true, hidesavebtn=true, hideresetbtn=true}), "FROS系统" , 1)
	entry({"admin", "system", "fros", "version_check"}, call("version_check")).leaf = true
    entry({"admin", "system", "fros", "upgrade_fros_ipk"}, call("upgrade_fros_ipk")).leaf = true
    entry({"admin", "system", "fros", "uninstall_fros_ipk"}, call("uninstall_fros_ipk")).leaf = true
    entry({"admin", "system", "fros", "get_install_log"}, call("get_install_log")).leaf = true
end


function get_fros_version()
    local version = sys.exec("cat /etc/version")
    if version == nil then
        return ""
    else
        return version
    end
end

function get_new_version()
    local version = sys.exec("cat /tmp/new_version")
    if version == nil then
        return ""
    else
        return version
    end
end
function get_install_log()
    local log_text = sys.exec("cat /tmp/log/fros_install.log")
    local resp_json= {
    }
    http.prepare_content("application/json") 
    resp_json.code = 20000
    resp_json.data = log_text
    http.write_json(resp_json)
end

function get_board_info()
    local board=util.trim(luci.sys.exec("cat /etc/os-release  | grep OPENWRT_BOARD | awk -F= '{print $2}' | xargs | awk -F/ '{print $1 \"-\" $2}'") )
    if board == nil then
        return ""
    else
        return board
    end
end

function get_kernel_version()
    return util.trim(luci.sys.exec("uname -a | awk '{print $3}'") )
end


function get_api_json(url)
    local jsonc = require "luci.jsonc"
    --local json_content = luci.sys.exec(curl .." -skL --connect-timeout 3  " .."'"..url.."'")
    luci.sys.exec("rm /tmp/info.json")
    luci.sys.exec(wget.." '"..url.."'".. " -O /tmp/info.json -T 3")
    local json_content = luci.sys.exec("cat /tmp/info.json")
    if json_content == "" then return nil end
    return jsonc.parse(json_content) or nil
end

function version_check(arch)
    local json = get_api_json(fros_api)

    resp_json= {
        code = '',
        url = {html = "", download = ""}
    }
    http.prepare_content("application/json")                     
    http.write_json(json)
end

function upgrade_fros_ipk(arch)
    local resp_json= {
        code=40005,
        data={}
    }
    http.prepare_content("application/json") 

    local board = get_board_info()
    local kernel = get_kernel_version()
    if board == nil or kernel == nil then
        resp_json.code = 40006
        http.write_json(resp_json)
        return
    end
  
    local url = fros_api.."?kernel="..kernel.."&arch="..board
    local json = get_api_json(url)
    if json == nil then
        http.write_json(resp_json)
        return
    end

    if json.code ~= 20000 then
        -- kernel
        if json.code == 40002 then 
            resp_json.code = 40008
            resp_json.msg = json.msg
        else
            -- arch
            resp_json.code = 40007 
            resp_json.msg = json.msg
        end
        http.write_json(resp_json)
        return
    end
   
    local result=util.trim(luci.sys.exec("fros_mgr upgrade "..json.data.url));
    code=tonumber(result)
    resp_json.code = code
    http.write_json(resp_json)
end

function uninstall_fros_ipk(arch)
    local resp_json= {
        code=20000,
    }
    http.prepare_content("application/json") 
    luci.sys.exec("fros_mgr uninstall");
    http.write_json(resp_json)
end
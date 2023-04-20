echo -e "\n该小工具可以为你检查本服务器到中国北京、上海、深圳的[回程网络]类型\n"
read -p "按Enter(回车)开始启动检查..." sdad

# Test IPs
ips=(219.141.136.12 202.106.50.1 221.179.155.161 202.96.209.133 210.22.97.1 211.136.112.200 58.60.188.222 210.21.196.6 120.196.165.24)
# ISP Names
names=(北京电信 北京联通 北京移动 上海电信 上海联通 上海移动 深圳电信 深圳联通 深圳移动)
# Log path
path=mtr_trace.log

# Check if mtr is installed
if [ ! -f /usr/bin/mtr ];then
	echo "未检测到mtr命令,正在安装..."
	# Check OS
	if [ -f /etc/redhat-release ];then
		yum clean all && yum makecache && yum install mtr -y
	else
		apt update -y && apt install mtr -y
	fi
fi

clear
echo -e "\n正在测试,请稍等..."
echo -e "——————————————————————————————\n"
for i in {0..8}; do
	mtr -r --n --tcp ${ips[i]} > $path
	grep -q "59\.43\." $path
	if [ $? == 0 ];then
		grep -q "202\.97\." $path
		if [ $? == 0 ];then
		echo -e "目标:${names[i]}[${ips[i]}]\t回程线路:\033[1;32m电信CN2 GT\033[0m"
		else
		echo -e "目标:${names[i]}[${ips[i]}]\t回程线路:\033[1;31m电信CN2 GIA\033[0m"
		fi
	else
		grep -q "202\.97\." $path
		if [ $? == 0 ];then
			grep -q "219\.158\." $path
			if [ $? == 0 ];then
			echo -e "目标:${names[i]}[${ips[i]}]\t回程线路:\033[1;33m联通169\033[0m"
			else
			echo -e "目标:${names[i]}[${ips[i]}]\t回程线路:\033[1;34m电信163\033[0m"
			fi
		else
				grep -q "218\.105\." $path
				if [ $? == 0 ];then
				echo -e "目标:${names[i]}[${ips[i]}]\t回程线路:\033[1;35m联通9929\033[0m"
				else
					grep -q "219\.158\." $path
					if [ $? == 0 ];then
						grep -q "219\.158\.113\." $path
						if [ $? == 0 ];then
						echo -e "目标:${names[i]}[${ips[i]}]\t回程线路:\033[1;33m联通AS4837\033[0m"
						else
						echo -e "目标:${names[i]}[${ips[i]}]\t回程线路:\033[1;33m联通169\033[0m"
						fi
					else				
						grep -q "223\.120\." $path
						if [ $? == 0 ];then
						echo -e "目标:${names[i]}[${ips[i]}]\t回程线路:\033[1;35m移动CMI\033[0m"
						else
							grep -q "221\.183\." $path
							if [ $? == 0 ];then
							echo -e "目标:${names[i]}[${ips[i]}]\t回程线路:\033[1;35m移动cmi\033[0m"
							else
							echo -e "目标:${names[i]}[${ips[i]}]\t回程线路:其他"
						fi
					fi
				fi
			fi
		fi
	fi
echo 
done
rm -f $path
echo -e "\n——————————————————————————————\n本脚本测试结果为TCP回程路由,非ICMP回程路由 仅供参考,以最新IP段为准 谢谢\n"

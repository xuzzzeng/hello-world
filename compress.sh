#!/bin/sh
echo "请输入要上线的分支名：(如master,dev,hotfix-xxx-xxx)" 
read branch;
source=/home/xuzeng/temp/deploy;
target=~/temp/tar;
project=git@192.168.1.106:web/rimag-web.git
if [ ! -d $source ];then
	echo "创建git仓库路径--------------$source";
	mkdir -p $source;
fi

if [ ! -d $source/rimag-web/.git  ];then
	cd $source;
	git clone $project;
fi

if [ -z $branch ];then
	echo "输入分支名格式不正确，即将退出。。。";
	exit;
else
	cd $source/rimag-web;
	git pull origin $branch > /dev/null;
	git checkout $branch > /dev/null;
	currBranch=`git branch | grep \* | cut -d ' ' -f2`;
	if [ ! -z $currBranch ];then
		echo "当前处于-------------$currBranch 分支";
	else
		echo "切换分支失败，你输入的分支有误或不存在";
	fi
	if [ ! -d $target ];then
		mkdir -p $target;
	fi
	for module in `ls $source/rimag-web/Application`;do
		cd $source/rimag-web/Application/;
		tar -zcvf  $target/$module.tar.gz $module > /dev/null	
		if [ `echo $?` -eq 0 ];then
			echo "$module -------success";
		else
			echo "$module -------------error";
		fi
	done
	if [ -d $source/rimag-web/Public/js ] && [ -d $source/rimag-web/Public/css ];then
                cd $source/rimag-web/Public;
		tar -zcvf  $target/js.tar.gz js > /dev/null;
		if [ `echo $?` -eq 0 ];then
			echo "js -------success";
		else
			echo "js -------------error"
		fi
		tar -zcvf  $target/css.tar.gz css > /dev/null;
		if [ `echo $?` -eq 0 ];then
			echo "css-------success";
		else
			echo "css-------------error"
		fi
	else
		echo "切换分支出错，输入的分支有误或不存在";
	fi
fi 



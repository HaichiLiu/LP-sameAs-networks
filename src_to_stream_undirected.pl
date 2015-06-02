#! /usr/bin/perl

use strict;
use warnings FATAL => 'all';

#这个脚本的作用是输入disease.txt文件,解析后
#输出:print STDOUT "$check,$vertex,$neighbor,$weight\n";print STDOUT "$check,$neighbor,$vertex,$weight\n";
#我的sameAs.txt文件同disease.txt有不同,主要表现在,后面一部分的weight值没有等于"f"的
#disease.txt中有7217-6208行的weight值等于f,
srand(1);

my %vertex_hash = ();

while( my $line = <STDIN>) {#读取输入文件的每一行
	chomp( $line );#去掉这一行字符串的换行符
	my ($d1,$d2,$weight) = split( /\s+/, $line );#用正则表达式切分行,并存入变量
	$d1 =~ s/^0+//;
	$d2 =~ s/^0+//;
	#读取行,并拆分成,两个数字,一个权重的
	
	# add vertices
	#将两个数字加入vertex映射表
	#建立vertice的映射表,如果映射表项还为空,则新加入一个映射关系
	if( !defined( $vertex_hash{$d1} ) ) {
		$vertex_hash{$d1} = {};
	}
	if( !defined( $vertex_hash{$d2} ) ) {
		$vertex_hash{$d2} = {};
	}
	
	
	# add edge with weight
	#添加边的权重,权重就是上步求得的weight,方向是双向的
	if( !defined( $vertex_hash{$d1}->{$d2} ) ) {
		$vertex_hash{$d1}->{$d2} = $weight;
	}
	if( !defined( $vertex_hash{$d2}->{$d1} ) ) {
		$vertex_hash{$d2}->{$d1} = $weight;
	}
}

foreach my $vertex (sort(keys(%vertex_hash))) {#遍历排序后的vertex_hash的主键,
	my $neighbor_hash_ref = $vertex_hash{$vertex};#取出主键对应的键值,存入自定义遍历neighbor_hash_ref中
	foreach my $neighbor (sort(keys(%{$neighbor_hash_ref}))) {#遍历排序后的neighbor_hash_ref的主键
		if( $vertex lt $neighbor ) {#如果vertex大于neighbor,无向图需要这个判断语句
			my $weight = $neighbor_hash_ref->{$neighbor};#定义自变量weight,等于$neighbor_hash_ref->{$neighbor}
			my $random = rand() * 10;#定义一个随机数,可能是1到10范围之内的
			foreach my $check (1..10) {#从1到10遍历,找到random的最小整数
				if( $random <= $check ) {
					#输出连接信息到文件
					print STDOUT "$check,$vertex,$neighbor,$weight\n";
					print STDOUT "$check,$neighbor,$vertex,$weight\n";
					last;#跳出循环
					#这里又是双向连接了
				}
			}#这段代码相当于把连接信息进行随机分配,例如随机数是4.8,那么会打印出5的连接信息
			#将来,根据编号,来分割训练和测试集
		}
	}
}


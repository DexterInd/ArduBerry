debug =1
def replace_in_file(filename,replace_from,replace_to):
	f = open(filename,'r')
	filedata = f.read()
	f.close()

	newdata = filedata.replace(replace_from,replace_to)

	f = open(filename,'w')
	f.write(newdata)
	f.close()

def check_bt_setting():
	flag=0
	if ('dtoverlay=pi3-miniuart-bt' in open('/boot/config.txt').read()) and ('#dtoverlay=pi3-miniuart-bt' in open('/boot/config.txt').read())==False:
		flag=1
		if debug:
			print "dtoverlay=pi3-miniuart-bt commented, bluetooth not working"
	if flag:
		return False
	return True
    
def disable_bt_setting():
	if check_bt_setting()==True:
		if('#dtoverlay=pi3-miniuart-bt' in open('/boot/config.txt').read()):	#setting is commented, uncomment it
			replace_in_file('/boot/config.txt',"#dtoverlay=pi3-miniuart-bt","dtoverlay=pi3-miniuart-bt")
		else: #no setting at all
			with open('/boot/config.txt', 'a') as file:
				file.write('dtoverlay=pi3-miniuart-bt\n')
def check_uart_setting():
	flag=0
	if ('#enable_uart=1' in open('/boot/config.txt').read())==False:
		if ('enable_uart=1' in open('/boot/config.txt').read())==True:
			flag=1
			if debug:
				print "enable_uart not commented, uart working"
	if flag:
		return True
	return False
    
def enable_uart_setting():
        if check_bt_setting()==False:
                if('#enable_uart=1' in open('/boot/config.txt').read()):    #setting is commented, uncomment it
                        replace_in_file('/boot/config.txt',"#enable_uart=1","enable_uart=1")
                else: #no setting at all
                        with open('/boot/config.txt', 'a') as file:
                                file.write('enable_uart=1\n')


if __name__ == "__main__":
	#print check_ir()
	disable_bt_setting()
	enable_uart_setting()

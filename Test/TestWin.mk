CODE = ..\Code
TEST_DATA = D:\Dropbox\AWS IOT
E1 = a2ucvb9nwvqrv6.iot.us-west-2.amazonaws.com 
R1 = "$(TEST_DATA)\VeriSign-Class 3-Public-Primary-Certification-Authority-G5.pem"
C1 = "$(TEST_DATA)\5988ca193a-certificate.pem.crt"
K1 = "$(TEST_DATA)\5988ca193a-private.pem.key"

C2 = "$(TEST_DATA)\b3877dc697-certificate.pem.crt"
K2 = "$(TEST_DATA)\b3877dc697-private.pem.key"

C3 = "$(TEST_DATA)\49f9eb7ca6-certificate.pem.crt"
K3 = "$(TEST_DATA)\49f9eb7ca6-private.pem.key"

Ex = a2ucvb9nwvqrv6.iot.us-west-2.amazonawsss.com

help:
    python $(CODE)\AwsIotPythonTest.py -h

dev1:
    python $(CODE)\AwsIotPythonTest.py -e "$(E1)" -r "$(R1)" -c "$(C1)" -k "$(K1)"
    
dev1-debug:
    python $(CODE)\AwsIotPythonTest.py -e "$(E1)" -r "$(R1)" -c "$(C1)" -k "$(K1)" -d 

dev1-pub-debug:
    python $(CODE)\AwsIotPythonTest.py -e "$(E1)" -r "$(R1)" -c "$(C1)" -k "$(K1)" -a publish -d
    
dev1-sub:
    python $(CODE)\AwsIotPythonTest.py -e "$(E1)" -r "$(R1)" -c "$(C1)" -k "$(K1)" -a subscribe    
   
dev1-sub-debug:
    python $(CODE)\AwsIotPythonTest.py -e "$(E1)" -r "$(R1)" -c "$(C1)" -k "$(K1)" -a subscribe -d 
   
dev2-sub:
	python $(CODE)\AwsIotPythonTest.py -e $(E1) -r $(R1) -c $(C3) -k $(K3) -a publish -i sensor2

dev3:
	python $(CODE)\AwsIotPythonTest.py -e $(E1) -r $(R1) -c $(C3) -k $(K3) -a subscribe -i mointor

#
# Test different devices.
# dev1-pub
# dev2-pub
# dev3-sub
#

dev1-pub:
	python $(CODE)\AwsIotPythonTest.py -e $(E1) -r $(R1) -c $(C1) -k $(K1) -a publish -i sensor1

dev2-pub:
	python $(CODE)\AwsIotPythonTest.py -e $(E1) -r $(R1) -c $(C2) -k $(K2) -a publish -i sensor2

dev3-sub:
	python $(CODE)\AwsIotPythonTest.py -e $(E1) -r $(R1) -c $(C3) -k $(K3) -a subscribe -i mointor
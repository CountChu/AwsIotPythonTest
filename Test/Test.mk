CODE = ../Code
TEST_DATA = ~/Dropbox/AWS\ IOT
E1 = a2ucvb9nwvqrv6.iot.us-west-2.amazonaws.com 
R1 = $(TEST_DATA)/VeriSign-Class\ 3-Public-Primary-Certification-Authority-G5.pem
C1 = $(TEST_DATA)/5988ca193a-certificate.pem.crt
K1 = $(TEST_DATA)/5988ca193a-private.pem.key

C2 = $(TEST_DATA)/b3877dc697-certificate.pem.crt
K2 = $(TEST_DATA)/b3877dc697-private.pem.key

C3 = $(TEST_DATA)/49f9eb7ca6-certificate.pem.crt
K3 = $(TEST_DATA)/49f9eb7ca6-private.pem.key

Ex = a2ucvb9nwvqrv6.iot.us-west-2.amazonawsss.com

help:
	python3 $(CODE)/AwsIotPythonTest.py -h

dev1:
	python3 $(CODE)/AwsIotPythonTest.py -e $(E1) -r $(R1) -c $(C1) -k $(K1)
    
dev1-debug:
	python3 $(CODE)/AwsIotPythonTest.py -e $(E1) -r $(R1) -c $(C1) -k $(K1) -d 

dev1-pub:
	python3 $(CODE)/AwsIotPythonTest.py -e $(E1) -r $(R1) -c $(C1) -k $(K1) -a publish

dev1-pub-debug:
	python3 $(CODE)/AwsIotPythonTest.py -e $(E1) -r $(R1) -c $(C1) -k $(K1) -a publish -d
    
dev1-sub:
	python3 $(CODE)/AwsIotPythonTest.py -e $(E1) -r $(R1) -c $(C1) -k $(K1) -a subscribe    
   
dev1-sub-debug:
	python3 $(CODE)/AwsIotPythonTest.py -e $(E1) -r $(R1) -c $(C1) -k $(K1) -a subscribe -d 

dev2-pub:
	python3 $(CODE)/AwsIotPythonTest.py -e $(E1) -r $(R1) -c $(C2) -k $(K2) -a publish

dev2-sub:
	python3 $(CODE)/AwsIotPythonTest.py -e $(E1) -r $(R1) -c $(C2) -k $(K2) -a subscribe    
   
dev3:
	python3 $(CODE)/AwsIotPythonTest.py -e $(E1) -r $(R1) -c $(C3) -k $(K3)

dev3-debug:
	python3 $(CODE)/AwsIotPythonTest.py -e $(E1) -r $(R1) -c $(C3) -k $(K3) -d

dev3-pub:
	python3 $(CODE)/AwsIotPythonTest.py -e $(E1) -r $(R1) -c $(C3) -k $(K3) -a publish

dev3-sub:
	python3 $(CODE)/AwsIotPythonTest.py -e $(E1) -r $(R1) -c $(C3) -k $(K3) -a subscribe

dev1-pub-s1:
	python3 $(CODE)/AwsIotPythonTest.py -e $(E1) -r $(R1) -c $(C1) -k $(K1) -a publish -i sensor1

dev1-pub-s2:
	python3 $(CODE)/AwsIotPythonTest.py -e $(E1) -r $(R1) -c $(C1) -k $(K1) -a publish -i sensor2

dev1-sub-m:
	python3 $(CODE)/AwsIotPythonTest.py -e $(E1) -r $(R1) -c $(C1) -k $(K1) -a subscribe -i mointor

dev1-pub-c1-t:
	python3 $(CODE)/AwsIotPythonTest.py -e $(E1) -r $(R1) -c $(C1) -k $(K1) -a publish -i c1 -t "A1/A2/A3/A4"

dev1-sub-c2-t:
	python3 $(CODE)/AwsIotPythonTest.py -e $(E1) -r $(R1) -c $(C1) -k $(K1) -a subscribe -i c2 -t "A1/A2/A3/A4"

#
# Test different devices.
# dev1-pub
# dev2-pub
# dev3-sub
#

dev1-pub:
	python3 $(CODE)/AwsIotPythonTest.py -e $(E1) -r $(R1) -c $(C1) -k $(K1) -a publish -i sensor1

dev2-pub:
	python3 $(CODE)/AwsIotPythonTest.py -e $(E1) -r $(R1) -c $(C2) -k $(K2) -a publish -i sensor2

dev3-sub:
	python3 $(CODE)/AwsIotPythonTest.py -e $(E1) -r $(R1) -c $(C3) -k $(K3) -a subscribe -i mointor

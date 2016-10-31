# AwsIotPythonTest - A Python Tool to Test AWS IoT

I modified the sample basicPubSub of the [aws-iot-device-sdk-python](https://github.com/aws/aws-iot-device-sdk-python) project to develop the Pyrhon tool, AwsIotPythonTest.py. It can be run in PC environment to test the AWS IoT service by sending actions (connect/publish/subscribe/receive) through MQTT. 

We can use the tool to emulate 3 connected devices, two sensors of temperature and one monitor. They are run in PC environment and  are connected to AWS IoT service. I'll describe the emulation in this topic later.

## Environment

- Please download and install the "AWS IoT Device SDK for Python" from the project, [aws-iot-device-sdk-python](https://github.com/aws/aws-iot-device-sdk-python).
- Please download the tool [AwsIotPythonTest](https://github.com/CountChu/AwsIotPythonTest).
- Check if you have Phton 3. I write the in Python 3, I'm not sure it is workable in Python 2.
- The tool can be run in Linux, MAC, or Windows.

## Command Arguments

The command arguments of the Python tool AwsIotPythonTest.py are described as below.

Usage 1 - Use certificate based mutual authentication:
```
python AwsIotPythonTest.py -e <endpoint> 
                           -r <rootCAFilePath> -c <certFilePath> -k <privateKeyFilePath>
```
Usage 2 - Use certificate based mutual authentication with action, optional clientid, and optional topic.
```
python AwsIotPythonTest.py -e <endpoint> 
                           -r <rootCAFilePath> -c <certFilePath> -k <privateKeyFilePath> 
                           -a <action> (-i <clientid>) (-t <topic>)
```

Type "python AwsIotPythonTest.py -h" for available options.
```
-e, --endpoint
    Your AWS IoT custom endpoint
-r, --rootCA
    Root CA file path
-c, --cert
    Certificate file path
-k, --key
    Private key file path
-h, --help
    Help information
-d, --debug
    Print debug messages.
-a, --action
    publish or subscribe
-i, --clientid
    Client ID
-t, --topic
    Topic
```

## Examples

Before using the test tool, please make sure that you have three certificates and an attached policy in your AWS IoT. If not, please sign in AWS IoT to create three certificates and a policy, to attach the policy to the 3 certificates.

### Policy1

The policy named Policy1 allows all client IDs to connect and to publish/subscribe/receive all topics.

```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "iot:Connect",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "iot:Publish",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "iot:Subscribe",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "iot:Receive",
      "Resource": "*"
    }
  ]
}
```

### Test.mk

The makefile defines targets to allow you to easily use the tool without typing long command in a console.

Note: The makefile is linux-style, it cannot be run in Windows envionment. 

Variables:
- E1 - Your AWS IoT custom endpoint. For example, The 12345678912345.iot is an endpoint, and The us-west-2 is a region.
- R1 - A root CA certificate is used by your device to ensure it is communicating with AWS IoT.
- C1 - A certificate of device 1 is created by you or by AWS IoT for you.
- K1 - A private key of the certificate C1.
- C2 - A certificate of device 2 is created by you or by AWS IoT for you.
- K2 - A private key of the certificate C2.
- C3 - A certificate of device 3 is created by you or by AWS IoT for you.
- K3 - A private key of the certificate C3.

Targets:
- dev1-pub-s1 - It emulates the sensor1 that publishes temperatures  
- dev2-pub-s2 - It emulates the sensor2 that publishes temperatures
- dev3-sub-m - It emulates the monitor that subscribes and receives temperatures.

```
E1 = 12345678912345.iot.us-west-2.amazonaws.com 
R1 = VeriSign-Class\ 3-Public-Primary-Certification-Authority-G5.pem
C1 = ??????????-certificate.pem.crt
K1 = ??????????-private.pem.key
C2 = ??????????-certificate.pem.crt
K2 = ??????????-private.pem.key
C3 = ??????????-certificate.pem.crt
K3 = ??????????-private.pem.key

dev1-pub:
    python AwsIotPythonTest.py -e $(E1) -r $(R1) -c $(C1) -k $(K1) -a publish -i sensor1

dev2-pub:
    python AwsIotPythonTest.py -e $(E1) -r $(R1) -c $(C1) -k $(K1) -a publish -i sensor2

dev3-sub:
    python AwsIotPythonTest.py -e $(E1) -r $(R1) -c $(C1) -k $(K1) -a subscribe -i mointor

```

### Run

After you prepare the ceritifcate, the policy, the tool, the AWS IoT Python SDK, and the makefile, you can open 3 consols to run the example.

Consol 1
```
>nmake -f Test.mk dev1-pub
```

Consol 2
```
>nmake -f Test.mk dev2-pub
```

Consol 3
```
>nmake -f Test.mk dev3-sub
```

You will see the below logs in the 3 consoles.

Consol 1
```
Publish the message, Client ID sensor1 - Seq 15: Temperature = 24.8
Publish the message, Client ID sensor1 - Seq 16: Temperature = 30.6
Publish the message, Client ID sensor1 - Seq 17: Temperature = 20.3
Publish the message, Client ID sensor1 - Seq 18: Temperature = 20.9
Publish the message, Client ID sensor1 - Seq 19: Temperature = 23.5
Publish the message, Client ID sensor1 - Seq 20: Temperature = 32.9
```

Consol 2
```
Publish the message, Client ID sensor2 - Seq 10: Temperature = 20.3
Publish the message, Client ID sensor2 - Seq 11: Temperature = 22.6
Publish the message, Client ID sensor2 - Seq 12: Temperature = 22.8
Publish the message, Client ID sensor2 - Seq 13: Temperature = 28.1
Publish the message, Client ID sensor2 - Seq 14: Temperature = 28.3
Publish the message, Client ID sensor2 - Seq 15: Temperature = 24.8
```

Consol 3
```
Received a new message: 
b'Client ID sensor2 - Seq 11: Temperature = 22.6'
from topic: 
sdk/test/temperature
--------------

Received a new message: 
b'Client ID sensor1 - Seq 16: Temperature = 30.6'
from topic: 
sdk/test/temperature
--------------

Received a new message: 
b'Client ID sensor2 - Seq 12: Temperature = 22.8'
from topic: 
sdk/test/temperature
--------------

Received a new message: 
b'Client ID sensor1 - Seq 17: Temperature = 20.3'
from topic: 
sdk/test/temperature
--------------
```





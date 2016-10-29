'''
//
// The tool is to test AWS IoT Python SDK. I modified the sample coming from,
// https://github.com/aws/aws-iot-device-sdk-python/blob/master/samples/basicPubSub/basicPubSub.py
// to develop the tool.
//
'''

'''
/*
 * Copyright 2010-2016 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */
 '''

import os
import sys
import AWSIoTPythonSDK
sys.path.insert(0, os.path.dirname(AWSIoTPythonSDK.__file__))
# Now the import statement should work 
from AWSIoTPythonSDK.MQTTLib import AWSIoTMQTTClient
import sys
import logging
import time
import getopt
from random import uniform

# Custom MQTT message callback
def customCallback(client, userdata, message):
    print("Received a new message: ")
    print(message.payload)
    print("from topic: ")
    print(message.topic)
    print("--------------\n")

# Usage
usageInfo = """
Usage 1 - Use certificate based mutual authentication:
python AwsIotPythonTest.py -e <endpoint> -r <rootCAFilePath> -c <certFilePath> -k <privateKeyFilePath>

Usage 2 - Use certificate based mutual authentication with action:
python AwsIotPythonTest.py -e <endpoint> -r <rootCAFilePath> -c <certFilePath> -k <privateKeyFilePath> -a <action> (-i <clientid>)

Type "python AwsIotPythonTest.py -h" for available options.
"""
# Help info
helpInfo = """
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
"""

#
# Read in command-line parameters
#

host = ""
rootCAPath = ""
certificatePath = ""
privateKeyPath = ""
debug = False                           # for -d option.
action = ""                             # for -a option that is publish, subscribe, or default "".        
clientId = ""                           # for -i option.
topic = "sdk/test/Python"               # for -t option.

try:
    opts, args = getopt.getopt(
        sys.argv[1:], 
        "dhwe:k:c:r:a:i:t:", 
        [
            "help", 
            "endpoint=", 
            "key=", 
            "cert=", 
            "rootCA=", 
            "action=", 
            "clientid=",
            "topic="
        ])
        
    if len(opts) == 0:
        raise getopt.GetoptError("No input parameters!")
    for opt, arg in opts:
        if opt in ("-h", "--help"):
            print(helpInfo)
            exit(0)
        if opt in ("-e", "--endpoint"):
            host = arg
        if opt in ("-r", "--rootCA"):
            rootCAPath = arg
        if opt in ("-c", "--cert"):
            certificatePath = arg
        if opt in ("-k", "--key"):
            privateKeyPath = arg
        if opt in ("-d", "--debug"):
            debug = True
        if opt in ("-a", "--action"):
            action = arg
        if opt in ("-i", "--clientid"):
            clientId = arg
        if opt in ("-t", "--topic"):
            topic = arg
            
except getopt.GetoptError:
    print(usageInfo)
    exit(1)

print ("Topic: %s" % topic)     

#    
# Missing configuration notification
#

missingConfiguration = False
if not host:
    print("Missing '-e' or '--endpoint'")
    missingConfiguration = True
if not rootCAPath:
    print("Missing '-r' or '--rootCA'")
    missingConfiguration = True
if not certificatePath:
    print("Missing '-c' or '--cert'")
    missingConfiguration = True
if not privateKeyPath:
    print("Missing '-k' or '--key'")
    missingConfiguration = True
if missingConfiguration:
    exit(2)

# Configure logging
logger = None
if sys.version_info[0] == 3:
    logger = logging.getLogger("core")  # Python 3
else:
    logger = logging.getLogger("AWSIoTPythonSDK.core")  # Python 2
    
if debug:    
    logger.setLevel(logging.DEBUG)
else:
    logger.setLevel(logging.INFO)
    
streamHandler = logging.StreamHandler()
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
streamHandler.setFormatter(formatter)
logger.addHandler(streamHandler)   

#
# Specify Client ID.
#
# "The message broker does not allow two clients with the same client ID to stay 
# connected at the same time.
#
# "After the second client connects, the broker detects this case and
# disconnects one of the clients."
#

if clientId == "":
    clientId = "AwsIotPythonTest"
    if action != "":
        clientId = clientId + "." + action     
print ("Client ID: %s" % clientId)

#
# Init AWSIoTMQTTClient
#

myAWSIoTMQTTClient = AWSIoTMQTTClient(clientId)
    
myAWSIoTMQTTClient.configureEndpoint(host, 8883)
myAWSIoTMQTTClient.configureCredentials(rootCAPath, privateKeyPath, certificatePath)

#
# AWSIoTMQTTClient connection configuration
#

myAWSIoTMQTTClient.configureAutoReconnectBackoffTime(1, 32, 20)
myAWSIoTMQTTClient.configureOfflinePublishQueueing(-1)  # Infinite offline Publish queueing
myAWSIoTMQTTClient.configureDrainingFrequency(2)  # Draining: 2 Hz
myAWSIoTMQTTClient.configureConnectDisconnectTimeout(10)  # 10 sec
myAWSIoTMQTTClient.configureMQTTOperationTimeout(5)  # 5 sec

#
# Connect and subscribe to AWS IoT
#

myAWSIoTMQTTClient.connect()
if action in ("", "subscribe"):
    myAWSIoTMQTTClient.subscribe(topic, 1, customCallback)
    time.sleep(2)

#
# Publish to the same topic in a loop forever
#

loopCount = 0
while True:
    if action in ("", "publish"):
        temperature = uniform (20.0, 40.0)
        message = "Client ID %s - Seq %d: Temperature = %.1f" % (clientId, loopCount, temperature)
        print ("Publish the message, %s" % message);
        myAWSIoTMQTTClient.publish(topic, message, 1)
        loopCount += 1
    time.sleep(1)

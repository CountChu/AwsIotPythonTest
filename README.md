# AwsIotPythonTest - A Python Test Tool to Test AWS IoT

## Usage

Usage 1 - Use certificate based mutual authentication:
```
python AwsIotPythonTest.py -e <endpoint> -r <rootCAFilePath> -c <certFilePath> -k <privateKeyFilePath>
```
Usage 2 - Use certificate based mutual authentication with action:
```
python AwsIotPythonTest.py -e <endpoint> -r <rootCAFilePath> -c <certFilePath> -k <privateKeyFilePath> 
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

jmeter-framework

Framework for running [Apache JMeter](http://jmeter.apache.org/).
More information on JMeter at [http://jmeter.apache.org/](http://jmeter.apache.org/)

### Workspace setup (UI needed for test suite creation)
This framework contains make setup target for the workspace.
It downloads a JMeter3.3 from with some extra plugins installed.

```
$> make jmeter_setup
``` 

You can also install downloading and following the docs on their [website](http://jmeter.apache.org/).

#### Starting JMeter UI

```
$> make jmeter_ui
```

#### Docker
```
$> docker run --rm -it \
    -v $(pwd)/tests:/opt/tests \
    -v $(pwd)/log:/opt/log \
    versent/jmeter:0.1 \
    /opt/jmeter/bin/jmeter.sh -n -t ./tests/default.jmx \
    -l log/results_2017-10-24-23_09_03 -e -o log/2017-10-24-23_09_03 \
    -Jusers=1 \
    -Jramp_up=1 \
    -Jprotocol=http \
    -Jaddress=www.smh.com.au \
    -Jport=80
```
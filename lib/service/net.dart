import 'dart:io';
// import 'dart:async';
// import 'package:dnsolve/dnsolve.dart';
// import 'dart:convert' show json;
// import 'package:flutter/services.dart';

/*
$ ip route show default
100.71.129.164/30 dev rmnet_data5 proto kernel scope link src 100.71.129.166 
192.168.100.0/24 dev wlan0 proto kernel scope link src 192.168.100.11

udp://127.0.0.53:53

String msg = await InetInterface._channel.invokeMethod('getPlatformInterfaces');

cat /proc/net/route (ip in hex)
*/

class NetService {

    /* Future<List<String>> findAllNameservers() async {

        // Set the network channel
        const MethodChannel methodChannel = MethodChannel('network');

        // Find all nameservers
        return methodChannel.invokeMethod('nameservers.findAll')
            .then((response) => json.decode(response).toList().cast<String>());
    } */

    List<Uri> getDefaultNameServers() {

        // Name servers list
        List<Uri> dnsServers = [];

        // /etc/resolv.conf
        File resolvConf = File('/etc/resolv.conf');
        if (resolvConf.existsSync()) {
            List<String> lines = resolvConf.readAsLinesSync();
            for (String line in lines) {
                if (line.startsWith('nameserver')) {
                    String ip = line.split(' ')[1].trim();
                    dnsServers.add(Uri.parse('udp://$ip:53'));
                }
            }
        }

        // /run/systemd/resolve/resolv.conf
        File systemdResolvConf = File('/run/systemd/resolve/resolv.conf');
        if (systemdResolvConf.existsSync()) {
            List<String> lines = systemdResolvConf.readAsLinesSync();
            for (String line in lines) {
                if (line.startsWith('nameserver')) {
                    String ip = line.split(' ')[1].trim();
                    dnsServers.add(Uri.parse('udp://$ip:53'));
                }
            }
        }

        /* // DoH
        File dohConf = File('/etc/dns-over-https.conf');
        if (dohConf.existsSync()) {
            List<String> lines = dohConf.readAsLinesSync();
            for (var line in lines) {
                if (line.startsWith('doh-server')) {
                    var uri = line.split(' ')[1].trim();
                    dnsServers.add(Uri.parse('https://$uri:443'));
                }
            }
        } */

        return dnsServers;
    }
}
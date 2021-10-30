import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class ContractLinking extends ChangeNotifier {
  final String _rpcUrl = "HTTP://127.0.0.1:7545";
  final String _wsUrl = "ws://127.0.0.1:7545";
  final String _privateKey =
      "6bd5f3224c7d00968d4f49727aa24baa3e6a80e01a3871026029472532276bb5";

  Web3Client _client;
  String _abiCode;

  EthereumAddress _contractAddress;
  Credentials _credentials;

  DeployedContract _contract;
  ContractFunction _countryName;
  ContractFunction _currentPopulation;
  ContractFunction _currentVaccinated ;
  ContractFunction _set;
  ContractFunction _setAll;
  ContractFunction _decrement;
  ContractFunction _increment;
  ContractFunction _decrementVaccinated;
  ContractFunction _incrementVaccinated;


  bool isLoading = true;
  String countryName;
  String currentPopulation;
  String currentVaccinated ="0";


  ContractLinking() {
    initialSetup();
  }

  initialSetup() async {
    _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });
    await getAbi();
    await getCredentials();
    await getDeployedContract();
  }

  Future<void> getAbi() async {
    final abiStringFile =
        await rootBundle.loadString("src/artifacts/Population.json");
    final jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);
    _contractAddress =
        EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);
  }

  Future<void> getCredentials() async {
    _credentials = await _client.credentialsFromPrivateKey(_privateKey);
  }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "Population"), _contractAddress);
    _countryName = _contract.function("countryName");
    _currentPopulation = _contract.function("currentPopulation");
    _currentVaccinated = _contract.function("currentVaccinated");
    _set = _contract.function("set");
    _setAll = _contract.function("setAll");
    _decrement = _contract.function("decrement");
    _increment = _contract.function("increment");
    _decrementVaccinated = _contract.function("decrementVaccinated");
    _incrementVaccinated = _contract.function("incrementVaccinated");


    getData();
  }

  getData() async {
    List name = await _client
        .call(contract: _contract, function: _countryName, params: []);
    List population = await _client
        .call(contract: _contract, function: _currentPopulation, params: []);
     List vaccinated = await _client
         .call(contract: _contract, function: _currentVaccinated, params: []);

    countryName = name[0];
    currentPopulation = population[0].toString();
    currentVaccinated = vaccinated[0].toString();
    print("$countryName , $currentPopulation , $currentVaccinated ");
    isLoading = false;
    notifyListeners();
  }

  addData(String nameData, BigInt countData) async {
    isLoading = true;
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _set,
            parameters: [nameData, countData]));
    getData();
  }

  addDataAll(String nameData, BigInt countData, BigInt vaccinatedData) async {
    isLoading = true;
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _setAll,
            parameters: [nameData, countData,vaccinatedData]));
    getData();
  }
  increasePopulation(int incrementBy) async {
    isLoading = true;
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _increment,
            parameters: [BigInt.from(incrementBy)]));
    getData();
  }

  increaseVaccinated(int incrementBy) async {
    isLoading = true;
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _incrementVaccinated,
            parameters: [BigInt.from(incrementBy)]));
    getData();
  }

  decreaseVaccinated(int decrementBy) async {
    isLoading = true;
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _decrementVaccinated,
            parameters: [BigInt.from(decrementBy)]));
    getData();
  }

  decreasePopulation(int decrementBy) async {
    isLoading = true;
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _decrement,
            parameters: [BigInt.from(decrementBy)]));
    getData();
  }
}

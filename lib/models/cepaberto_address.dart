import 'package:dio/dio.dart';

class CepAbertoAddress {
  final double altitude;
  final String cep;
  final double? latitude;
  final double? longitude;
  final String logradouro;
  final String bairro;
  final Cidade cidade;
  final Estado estado;

  CepAbertoAddress.fromMap(Response map)
      :altitude = map.data['altitude'] as double,
        cep = map.data['cep'] as String,
        latitude = double.tryParse(map.data['latitude'] as String),
        longitude = double.tryParse(map.data['longitude'] as String),
        logradouro = map.data['logradouro'] as String,
        bairro = map.data['bairro'] as String,
        cidade = Cidade.fromMap(map.data['cidade'] as Map<String, dynamic>),
        estado = Estado.fromMap(map.data['estado'] as Map<String, dynamic>);

  @override
  String toString() {
    return 'CepAbertoAddress{altitude: $altitude, cep: $cep, latitude: $latitude, longitude: $longitude, logradouro: $logradouro, bairro: $bairro, cidade: $cidade, estado: $estado}';
  }
}

class Cidade {
  final int ddd;
  final String ibge;
  final String nome;

  Cidade.fromMap(Map<String, dynamic> map)
      : ddd = map['ddd'] as int,
        ibge = map['ibge'] as String,
        nome = map['nome'] as String;

  @override
  String toString() {
    return 'Cidade{ddd: $ddd, ibge: $ibge, nome: $nome}';
  }
}

class Estado {
  final String sigla;

  Estado.fromMap(Map<String, dynamic> map) : sigla = map['sigla'] as String;

  @override
  String toString() {
    return 'Estado{sigla: $sigla}';
  }
}

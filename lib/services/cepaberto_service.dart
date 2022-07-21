import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:ecommerce_app/models/cepaberto_address.dart';

const token = 'e754e407e25e66e47b6fe5486e2353b5';

class CepAbertoService {
  Future<CepAbertoAddress> getAddressFromCep(String cep) async {
    final cleanCep = cep.replaceAll('.', '').replaceAll('-', '');
    final endpoint = "https://www.cepaberto.com/api/v3/cep?cep=$cleanCep";

    final Dio dio = Dio();

    dio.options.headers[HttpHeaders.authorizationHeader] = 'Token token=$token';

    try {
      final response = await dio.get(endpoint);
      if (response.data == {}) {
        return Future.error('CEP Inválido');
      }
      final CepAbertoAddress address = CepAbertoAddress.fromMap(response);
      return address;

    } on DioError catch (e) {
      return Future.error('Erro ao buscar CEP');
    }
  }
}

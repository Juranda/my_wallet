import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_wallet/app/home/organizador_gastos/models/transaction.dart';
import 'package:my_wallet/models/expenses/categoria.dart';
import 'package:my_wallet/providers/user_provider.dart';
import 'package:my_wallet/services/mywallet.dart';
import 'package:provider/provider.dart';

class TransactionForm extends StatefulWidget {
  TransactionForm({
    required this.categorias,
  });

  final List<Categoria> categorias;

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final titleController = TextEditingController();
  final valueController = TextEditingController();
  late DateTime _selectedDate = DateTime.now();
  late Categoria selectedCategoria;

  void _submitForm() {
    UserProvider userProvider = Provider.of(context, listen: false);
    final title = titleController.text;
    final value = double.tryParse(valueController.text) ?? 0;

    if (title.isEmpty || value == 0) {
      return;
    }

    Navigator.pop(context);

    final createTransaction = CreateTransaction(
      idUsuario: userProvider.usuario.id_usuario,
      idCategoria: selectedCategoria.id,
      title: title,
      value: value,
      date: DateTime.parse(_selectedDate.toIso8601String()),
    );

    MyWallet.expensesService.inserirTransacao(createTransaction);
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) return;

      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    selectedCategoria = widget.categorias.first;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Titulo',
              ),
              controller: titleController,
              onSubmitted: (_) => _submitForm(),
            ),
            TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: 'Valor (R\$)'),
              controller: valueController,
              onSubmitted: (_) => _submitForm(),
            ),
            Container(
              height: 70,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Data selecionada: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _showDatePicker();
                    },
                    child: Text(
                      'Selecionar data',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
            if (widget.categorias.isNotEmpty)
              DropdownButton(
                isExpanded: true,
                hint: const Text('Categoria'),
                items: widget.categorias
                    .map(
                      (categoria) => DropdownMenuItem(
                        child: Text(categoria.nome),
                        value: categoria,
                      ),
                    )
                    .toList(),
                onChanged: (e) => setState(() {
                  selectedCategoria = e as Categoria;
                }),
                value: selectedCategoria,
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                      (states) => Theme.of(context).primaryColor,
                    ),
                  ),
                  onPressed: () => _submitForm(),
                  child: Text(
                    'Nova transação',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

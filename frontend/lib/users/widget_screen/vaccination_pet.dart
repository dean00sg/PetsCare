import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/users/bloc/vaccination_pet.dart';
import 'package:frontend/users/models/vaccination_pet.dart';
import 'package:frontend/users/state/vaccination_pet.dart';
import 'package:frontend/users/event/vaccination_pet.dart';
import 'package:frontend/users/styles/petprofile_style.dart';

class VaccinePetsScreen extends StatelessWidget {
  const VaccinePetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final petsId = arguments['petsId'] as int;
    final petName = arguments['name'] as String;
    final imagePath = arguments['image'] as String;

    context
        .read<PetVacUserBloc>()
        .add(LoadPetVacUserProfile(petsId.toString()));

    //Tab Bar
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: PetProfileStyles.appBarBackgroundColor,
        centerTitle: true,
        toolbarHeight: 70,
        title: const Text('Vaccine', 
        style: TextStyle(
          fontSize: 22,
          color: Colors.white,
          )),
      ),
      body: SingleChildScrollView( //ป้องกันการล้นจอ
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.05, //ระยะห่างขอบบน
                16.0,
                MediaQuery.of(context).size.width * 0.05, //ระยะห่างขอบล่าง
                0.0,
              ),
              //Pet Name
              child: Container(
                width: double.infinity,
                color: const Color.fromARGB(255, 200, 90, 90), //container of pet name
                height: 80,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage(imagePath),
                    ),
                    //const SizedBox(width: 8),
                    Text(
                      ' $petName',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.05,
                0.0,
                MediaQuery.of(context).size.width * 0.05,
                16.0,
              ),
              child: Container(
                width: double.infinity,
                color: const Color(0xFFF2B8B5), //container main of vaccine infor
                child: BlocBuilder<PetVacUserBloc, PetVacUserState>(
                  builder: (context, state) {
                    if (state is PetVacUserLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is PetVacUserError) {
                      return Center(child: Text('Error: ${state.error}'));
                    } else if (state is PetVacUserLoaded) {
                      return Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.vacUserProfiles.length,
                            itemBuilder: (context, index) {
                              final vaccine = state.vacUserProfiles[index]; //ปรับขนาด container ตามจำนวนวัคซีน
                              return _buildVaccineContainer(vaccine, index + 1);
                            },
                          ),
                          //const SizedBox(height: 8),
                          _buildAddVaccineButton(context),
                        ],
                      );
                    } else {
                      return const Center(
                          child: Text('No vaccine data available'));
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVaccineContainer(PetVacUserProfile vaccine, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,  //container of vaccine infor
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFD3B8AE), //container of vaccine dose 
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Vaccine Dose: ${vaccine.dose}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          //Vaccine infor
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Vaccine Name: ', 
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Text(
                  vaccine.vacName,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Datetime: ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Text(
                  vaccine.startDateVac,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Location: ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Text(
                  vaccine.location,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Remark: ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Text(
                  vaccine.remark,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddVaccineButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //bottmon Add Vaccine
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Color(0xFFF2B8B5),
                child: Icon(Icons.add, color: Colors.white),
              ),
              SizedBox(width: 8),
              Text(
                'Add Vaccine',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

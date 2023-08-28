import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jobs/apply.dart';
import 'package:jobs/job_details.dart';
import 'package:jobs/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Job {
  final String id;
  final String title;
  final String image;
  final String email;
  final String companyName;
  final String website;
  final String category;
  final String salary;
  final String location;
  final String jobNature;
  final String applicationDate;
  final List<String> requiredKnowledge;
  final List<String> experience;
  final String description;
  final bool isActive;

  Job({
    required this.id,
    required this.title,
    required this.image,
    required this.email,
    required this.companyName,
    required this.website,
    required this.category,
    required this.salary,
    required this.location,
    required this.jobNature,
    required this.applicationDate,
    required this.requiredKnowledge,
    required this.experience,
    required this.description,
    required this.isActive,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      email: json['email'],
      companyName: json['companyName'],
      website: json['website'],
      category: json['category'],
      salary: json['salary'],
      location: json['location'],
      jobNature: json['jobNature'],
      applicationDate: json['applicationDate'],
      requiredKnowledge: List<String>.from(json['requiredKnowledge']),
      experience: List<String>.from(json['experience']),
      description: json['description'],
      isActive: json['isActive'],
    );
  }
}

class JobsList extends StatefulWidget {
  @override
  _JobsListState createState() => _JobsListState();
}

class _JobsListState extends State<JobsList> {
  List<Job> jobs = [];
  List<User> users = [];
  bool isLoading = false;
  late String user;

  @override
  void initState() {
    super.initState();
    fetchData();
    getLoggedInUserId();
  }

  Future<void> fetchData() async {
    try {
      setState(() {
        isLoading = true;
      });

      final response = await Dio().get('http://192.168.42.10:5000/api/jobs');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        setState(() {
          jobs = jsonList.map((json) => Job.fromJson(json)).toList();
        });
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getLoggedInUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user');
    setState(() {
      user = userId ?? '';
    });
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
    Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jobs List'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: isLoading ? null : signOut,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                final job = jobs[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JobDetailsPage(job),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: job.image.toLowerCase().endsWith('.svg')
                              ? SvgPicture.network(
                                  job.image,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  job.image,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                job.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                job.companyName,
                                style: TextStyle(fontSize: 14.0),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                job.location,
                                style: TextStyle(fontSize: 14.0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}


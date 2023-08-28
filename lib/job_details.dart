import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jobs/apply.dart';
import 'package:jobs/jobs.dart';

class JobDetailsPage extends StatelessWidget {
  final Job job;
 

  JobDetailsPage(this.job,);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
                Container(
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
                        
              SizedBox(height: 16.0),
              Text(
                'Title: ${job.title}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
              SizedBox(height: 8.0),
              Text('Company: ${job.companyName}', style: TextStyle(fontSize: 16.0)),
              SizedBox(height: 8.0),
              Text('Location: ${job.location}', style: TextStyle(fontSize: 16.0)),
              SizedBox(height: 16.0),
              Text('Description:', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
              SizedBox(height: 8.0),
              Text(job.description, style: TextStyle(fontSize: 16.0)),
              SizedBox(height: 16.0),
           ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ApplyPage(jobId: job.id, context: context,),
    
      ),
    );
  },
  child: Text('Apply Now'),
),

              SizedBox(height: 16.0),
     
            ],
          ),
        ),
      ),
    );
  }
}
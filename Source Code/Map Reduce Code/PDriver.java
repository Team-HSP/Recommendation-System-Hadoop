import java.io.IOException;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;


public class PDriver {

	/**
	 * @param args
	 */
	public static void main(String args[]) throws IOException, ClassNotFoundException, InterruptedException
	{
		System.out.println("**In driver Class**");
		Configuration conf = new Configuration();
		Job job = new Job(conf,"ProfileJob");
		
				
		job.setJarByClass(PDriver.class);	
		job.setMapperClass(PMapper.class);
		job.setReducerClass(PReducer.class);
		job.setCombinerClass(PReducer.class);
		
		job.setOutputKeyClass(Text.class);
		job.setOutputValueClass(Text.class);
		
		//conf.set("mapreduce.output.textoutputformat.separator", ";");
		
		FileInputFormat.addInputPath(job, new Path(args[0]));
		FileOutputFormat.setOutputPath(job, new Path(args[1]));
		
		//FileOutputFormat.setCompressOutput(job,true);
		//FileOutputFormat.setOutputCompressorClass(job, SnappyCodec.class);
		
		System.exit(job.waitForCompletion(true)?0:1);
	}

}

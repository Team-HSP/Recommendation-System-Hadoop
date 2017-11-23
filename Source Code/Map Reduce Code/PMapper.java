import java.io.IOException;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;


public class PMapper extends Mapper<Object,Text,Text,Text>
	{
		public void map(Object key,Text value,Context context) throws IOException, InterruptedException
		{
			String ar[] = value.toString().split("\t");
			Text uid = new Text(ar[0]);
			Text val = new Text(ar[1]+"\t"+ar[2]);
			context.write(uid, val);
		}
	}

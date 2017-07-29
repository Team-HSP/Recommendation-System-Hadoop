import java.io.IOException;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

public class PReducer extends Reducer<Text,Text,Text,Text>
	{
		public void reduce(Text key,Iterable<Text> values,Context context) throws IOException, InterruptedException
		{
			int ar[] = new int[1683];
			for(Text val:values)
			{
				String a[] = val.toString().split("\t");
				int it = Integer.parseInt(a[0].toString());
				ar[it] = 1;
				context.write(key, val);
			}
			for(int i=1;i<=1682;i++)
			{
				if(ar[i]==0)
					context.write(key,new Text(Integer.toString(i)+"\t"+"0"));
			}
		}
	}
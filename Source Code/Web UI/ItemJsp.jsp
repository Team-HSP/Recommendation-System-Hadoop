<!DOCTYPE html>
<%@ page import="javax.servlet.http.*,javax.servlet.*,java.io.*,java.util.*,com.mongodb.*"%>
<html>
    <head>
        <title>Item Page</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        <link href="css/bootstrap.min.css" rel="stylesheet" media="screen">
        <link rel="stylesheet" href="css/bootstrap-responsive.min.css" type="text/css"/>

        <style>
            body{
                background-image:url("me2.jpg");
                color:#ffffff;
            }
            .aa{ width:415px; height:350px;
                    background-color:rgba(0,0,0,0.5); margin-top: 80px;padding-top: 40px;}
        </style>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
    </head>
    <body>
<%
	try{
		
        	 	MongoClient mongo = new MongoClient("localhost", 27017);
	 	 	DB db = mongo.getDB("rsystem");
	 	 	
		 	response.setContentType("text/html");
		 	
			int itemid = Integer.parseInt(request.getParameter("itemid"));
	 	
			BasicDBObject bdo1 = new BasicDBObject();
			bdo1.put("itemid", itemid);

	 		DBCollection coll1 = db.getCollection("items");
         		DBObject obj = coll1.findOne(bdo1);

			
	 	
%>
	<h1 style="color:black;">Item Details</h1>
	<h2 style="color:black;">Movie ID :</h2><h2><%=itemid%></h2>
	<h2 style="color:black;">Movie Title :</h2><h2><%=obj.get("itemtitle")%></h2>
	<h4 style="color:black;">IMBD Url :</h4><h4><%=obj.get("url")%></h4>
	<h4 style="color:black;">Release Date :</h4><h4><%=obj.get("release_date")%></h4>
	<br>
	<h3 style="color:black;">Genres :</h3>
<%				
			int i = 1;
			for(i=1;i<=18;i++)
			{
				String g = "g"+Integer.toString(i);
				int val = (Integer)obj.get(g);
				if(val==1)
				{
					BasicDBObject bdo2 = new BasicDBObject();
					bdo2.put("gid", i);

	 				DBCollection coll2 = db.getCollection("genre");
         				DBObject obj2 = coll2.findOne(bdo2);
%>
				<h4><%=obj2.get("genre")%></h4>
<%
				}

			}  			
		
		}
		catch(Exception e)
		{
        		System.err.println( e.getClass().getName() + ": " + e.getMessage() );
		}
%>  
</body>
</html>

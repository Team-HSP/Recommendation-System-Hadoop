<!DOCTYPE html>
<%@ page import="javax.servlet.http.*,javax.servlet.*,java.io.*,java.util.*,com.mongodb.*"%>
<html>
    <head>
        <title>User Home</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        <link href="css/bootstrap.min.css" rel="stylesheet" media="screen">
        <link rel="stylesheet" href="css/bootstrap-responsive.min.css" type="text/css"/>

        <style>
            body{
                background-image:url("me2.jpg");
                color:#000000;
            }
            
		a{
			color:black;
		}

	
			.bb {
    
    background-color: rgba(0,0,0,0.5);
    margin-top: 10px;
    padding-top: 0px;
    margin-left: 150px;
}
			
			
			
			
			.cc{  
                    background-color:rgba(0,0,0,0.5); margin-top: 10px;padding-top: 0px;margin-left: 150px;}
			
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
		 	
			int uid = Integer.parseInt(request.getParameter("uid"));
	 	
			BasicDBObject bdo1 = new BasicDBObject();
			bdo1.put("uid", uid);

	 		DBCollection coll1 = db.getCollection("users");
         		DBObject obj = coll1.findOne(bdo1);
	 	
%>
		<h1>Welcome User : <%=uid%></h1>
		<h3>Your Details</h3>
		<table style="width:75%; margin-left: 140px; color:white;">
  		<thead class="thead-inverse">
    			<tr>
      				<th>Age</th>
      				<th>Gender</th>
      				<th>Occupation</th>
				<th>Zip Code</th>
   			 </tr>
  		</thead>
  		<tbody>
			<tr>
				<td><%=obj.get("age")%></td>
      				<td><%=obj.get("gender")%></td>
      				<td><%=obj.get("occupation")%></td>
				<td><%=obj.get("zip")%></td>			
			</tr>
		</tbody>
		</table>
		<hr>
<%				
    			
		}
		catch(Exception e)
		{
        		System.err.println( e.getClass().getName() + ": " + e.getMessage() );
		}
%>   
      
<div  style="height:100%; width:50%;position:absolute">
        <h3 style="margin-top: 70px; margin-left: 200px; margin-bottom: 20px;">CUSTOMER RATINGS</h3>
		
		<table class="table" style="width:75%; margin-left: 140px; color:white;">
  <thead class="thead-inverse">
    <tr>
      <th>#MovieID</th>
      <th>Movie Title</th>
      <th>Movie Rating</th>
    </tr>
  </thead>
  <tbody>

 <%
		try{
		
        	 	MongoClient mongo = new MongoClient("localhost", 27017);
	 	 	DB db = mongo.getDB("rsystem");
	 	 	
		 	response.setContentType("text/html");
		 	
			int uid = Integer.parseInt(request.getParameter("uid"));
	 	
			BasicDBObject bdo1 = new BasicDBObject();
			bdo1.put("uid", uid);

	 		DBCollection coll1 = db.getCollection("uir");
         		DBCursor cursor1 = coll1.find(bdo1);
		
			while (cursor1.hasNext())
			{
 				
				DBObject resultElement1 = cursor1.next();
    				Map resultElementMap1 = resultElement1.toMap();
    				Collection c1 = resultElementMap1.values();
				Iterator it1 = c1.iterator();
				it1.next();it1.next();
				int itemid = (Integer)it1.next();
				int rating = (Integer)it1.next();
				
				BasicDBObject bdo2 = new BasicDBObject();
				bdo2.put("itemid", itemid);
				
				DBCollection coll2 = db.getCollection("items");
         			DBObject obj = coll2.findOne(bdo2);
							
					
%>
				<tr>
      					<th scope="row"><%=itemid%></th>
					<td><a href="ItemJsp.jsp?itemid=<%=itemid%>"><%=obj.get("itemtitle")%></a></td>  						<td><%=rating%></td>
	      			</tr>
<%
			}						
    			
		}
		catch(Exception e)
		{
        		System.err.println( e.getClass().getName() + ": " + e.getMessage() );
		}
%>   
</tbody>
</table>
</div>
<div style="height:100%; width:50%; left:50%;position:absolute">
		<h3 style="margin-top: 70px; margin-left: 140px; margin-bottom: 20px;">Hybrid Model Recommendations</h3>
		
		<table class="table" style="width:75%; margin-left: 140px; color:white;">
  <thead class="thead-inverse">
    <tr>
      <th>#MovieId</th>
      <th>Movie Titel</th>
    </tr>
  </thead>
  <tbody>
<%
		try{
		
        	 	MongoClient mongo = new MongoClient("localhost", 27017);
	 	 	DB db = mongo.getDB("rsystem");
	 	 	
		 	response.setContentType("text/html");
		 	
			int uid = Integer.parseInt(request.getParameter("uid"));
	 	
			BasicDBObject bdo1 = new BasicDBObject();
			bdo1.put("uid", uid);

	 		DBCollection coll1 = db.getCollection("hybrid");
         		DBCursor cursor1 = coll1.find(bdo1);
		
			while (cursor1.hasNext())
			{
 				
				DBObject resultElement1 = cursor1.next();
    				Map resultElementMap1 = resultElement1.toMap();
    				Collection c1 = resultElementMap1.values();
				Iterator it1 = c1.iterator();
				it1.next();it1.next();
				int itemid = (Integer)it1.next();
							
				BasicDBObject bdo2 = new BasicDBObject();
				bdo2.put("itemid", itemid);
				
				DBCollection coll2 = db.getCollection("items");
         			DBObject obj = coll2.findOne(bdo2);
							
					
%>
				<tr>
      					<th scope="row"><%=itemid%></th>
					<td><a href="ItemJsp.jsp?itemid=<%=itemid%>"><%=obj.get("itemtitle")%></a></td>
	      			</tr>
<%
			}						
			
		}
		catch(Exception e)
		{
        		System.err.println( e.getClass().getName() + ": " + e.getMessage() );
		}
%>
    
</tbody>
</table>

<h3 style="margin-top: 70px; margin-left: 140px; margin-bottom: 20px;">Collaborative Model Recommendations</h3>
		
		<table class="table" style="width:75%; margin-left: 140px; color:white;">
  <thead class="thead-inverse">
    <tr>
      <th>#MovieId</th>
      <th>Movie Titel</th>
    </tr>
  </thead>
  <tbody>
<%
		try{
		
        	 	MongoClient mongo = new MongoClient("localhost", 27017);
	 	 	DB db = mongo.getDB("rsystem");
	 	 	
		 	response.setContentType("text/html");
		 	
			int uid = Integer.parseInt(request.getParameter("uid"));
	 	
			BasicDBObject bdo1 = new BasicDBObject();
			bdo1.put("uid", uid);

	 		DBCollection coll1 = db.getCollection("collab");
         		DBCursor cursor1 = coll1.find(bdo1);
		
			while (cursor1.hasNext())
			{
 				
				DBObject resultElement1 = cursor1.next();
    				Map resultElementMap1 = resultElement1.toMap();
    				Collection c1 = resultElementMap1.values();
				Iterator it1 = c1.iterator();
				it1.next();it1.next();
				int itemid = (Integer)it1.next();
							
				BasicDBObject bdo2 = new BasicDBObject();
				bdo2.put("itemid", itemid);
				
				DBCollection coll2 = db.getCollection("items");
         			DBObject obj = coll2.findOne(bdo2);
							
					
%>
				<tr>
      					<th scope="row"><%=itemid%></th>
					<td><a href="ItemJsp.jsp?itemid=<%=itemid%>"><%=obj.get("itemtitle")%></a></td>
	      			</tr>
<%
			}						
			
		}
		catch(Exception e)
		{
        		System.err.println( e.getClass().getName() + ": " + e.getMessage() );
		}
%>   
  </tbody>
</table>

<h3 style="margin-top: 70px; margin-left: 140px; margin-bottom: 20px;">ContentBased Model Recommendations</h3>
		
		<table class="table" style="width:75%; margin-left: 140px; color:white;">
  <thead class="thead-inverse">
    <tr>
      <th>#MovieId</th>
      <th>Movie Titel</th>
    </tr>
  </thead>
  <tbody>
    <%
		try{
		
        	 	MongoClient mongo = new MongoClient("localhost", 27017);
	 	 	DB db = mongo.getDB("rsystem");
	 	 	
		 	response.setContentType("text/html");
		 	
			int uid = Integer.parseInt(request.getParameter("uid"));
	 	
			BasicDBObject bdo1 = new BasicDBObject();
			bdo1.put("uid", uid);

	 		DBCollection coll1 = db.getCollection("content");
         		DBCursor cursor1 = coll1.find(bdo1);
		
			while (cursor1.hasNext())
			{
 				
				DBObject resultElement1 = cursor1.next();
    				Map resultElementMap1 = resultElement1.toMap();
    				Collection c1 = resultElementMap1.values();
				Iterator it1 = c1.iterator();
				it1.next();it1.next();
				int itemid = (Integer)it1.next();
							
				BasicDBObject bdo2 = new BasicDBObject();
				bdo2.put("itemid", itemid);
				
				DBCollection coll2 = db.getCollection("items");
         			DBObject obj = coll2.findOne(bdo2);
							
					
%>
				<tr>
      					<th scope="row"><%=itemid%></th>
					<td><a href="ItemJsp.jsp?itemid=<%=itemid%>"><%=obj.get("itemtitle")%></a></td>
	      			</tr>
<%
			}						
			
		}
		catch(Exception e)
		{
        		System.err.println( e.getClass().getName() + ": " + e.getMessage() );
		}
%>
</tbody>
</table>
</div>
</body>
</html>




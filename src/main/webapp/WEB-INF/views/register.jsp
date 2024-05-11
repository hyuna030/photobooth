<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<html>
<head>
    <style>
        body {
            background-color: #E5BDB0;
            color: white;
            text-align: center;
        }

        h2 {
            font-size: 40px;
        }

        label {
            display: block;
            font-size: 40px;
            margin-bottom: 20px;
        }

        input[type="text"],
        input[type="password"] {
            font-size: 40px;
            padding: 10px;
            margin-bottom: 20px;
        }

        input[type="submit"] {
            font-size: 40px;
            padding: 10px 30px;
        }

        span {
            color: red;
            font-size: 40px;
        }
    </style>
    <title>회원가입</title>
</head>
<body>
    <h2>회원가입</h2>
    <form:form action="/register" method="post" modelAttribute="user">
        <label for="username">사용자명:</label>
        <form:input id="username" path="username" required="true" />
        <br><br>
        <label for="password">비밀번호:</label>
        <form:password id="password" path="password" required="true" />
        <br><br>
        <span style="color: red">${error}</span>
        <br><br>
        <input type="submit" value="회원가입" />
    </form:form>
</body>
</html>
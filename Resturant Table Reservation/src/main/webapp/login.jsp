<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login - TableBook</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = { theme: { extend: { colors: { orange: { 500: '#f97316' } }, fontFamily: { sans: ['Inter', 'sans-serif'] } } } }
    </script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Heroicons -->
    <script src="https://unpkg.com/feather-icons"></script>
    <style>
        body { font-family: 'Inter', sans-serif; }
        .glass { background: rgba(30, 41, 59, 0.4); backdrop-filter: blur(24px); border: 1px solid rgba(255, 255, 255, 0.1); }
        .toast-enter { animation: toast-in 0.5s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
        @keyframes toast-in { 0% { transform: translateY(-100%); opacity: 0; } 100% { transform: translateY(0); opacity: 1; } }
    </style>
</head>
<body class="bg-slate-950 text-slate-200 min-h-screen flex">
    
    <!-- Toast Alerts -->
    <div class="fixed top-6 left-1/2 transform -translate-x-1/2 z-50 w-full max-w-md px-4 pointer-events-none">
        <% if (request.getParameter("error") != null) { %>
            <div class="toast-enter pointer-events-auto flex items-center gap-3 bg-red-950/80 backdrop-blur-md border border-red-500/50 text-red-200 p-4 rounded-2xl shadow-[0_10px_40px_-10px_rgba(239,68,68,0.5)]">
                <i data-feather="alert-circle" class="text-red-500"></i>
                <p class="font-medium"><%= request.getParameter("error") %></p>
            </div>
        <% } %>
        <% if (request.getParameter("success") != null) { %>
            <div class="toast-enter pointer-events-auto flex items-center gap-3 bg-green-950/80 backdrop-blur-md border border-green-500/50 text-green-200 p-4 rounded-2xl shadow-[0_10px_40px_-10px_rgba(34,197,94,0.5)]">
                <i data-feather="check-circle" class="text-green-500"></i>
                <p class="font-medium"><%= request.getParameter("success") %></p>
            </div>
        <% } %>
    </div>

    <!-- Left: Form -->
    <div class="w-full lg:w-1/2 flex items-center justify-center p-8 lg:p-24 relative z-10">
        <div class="w-full max-w-md">
            <h1 class="text-4xl font-bold tracking-tight mb-2">Table<span class="text-orange-500">Book</span></h1>
            <p class="text-slate-400 mb-10 text-lg">Welcome back. Enter your details to access your account.</p>

            <form action="${pageContext.request.contextPath}/auth/login" method="post" class="space-y-6">
                <div>
                    <label class="block text-sm font-medium text-slate-300 mb-2">Email Address</label>
                    <div class="relative">
                        <i data-feather="mail" class="absolute left-4 top-1/2 transform -translate-y-1/2 text-slate-500 w-5 h-5"></i>
                        <input type="email" name="email" class="w-full bg-slate-900/50 border border-slate-700/50 rounded-xl pl-12 pr-4 py-3.5 focus:outline-none focus:border-orange-500 focus:ring-1 focus:ring-orange-500 transition-all text-white placeholder-slate-600" placeholder="name@example.com" required>
                    </div>
                </div>
                <div>
                    <label class="block text-sm font-medium text-slate-300 mb-2">Password</label>
                    <div class="relative">
                        <i data-feather="lock" class="absolute left-4 top-1/2 transform -translate-y-1/2 text-slate-500 w-5 h-5"></i>
                        <input type="password" name="password" class="w-full bg-slate-900/50 border border-slate-700/50 rounded-xl pl-12 pr-4 py-3.5 focus:outline-none focus:border-orange-500 focus:ring-1 focus:ring-orange-500 transition-all text-white placeholder-slate-600" placeholder="••••••••" required>
                    </div>
                </div>
                <button type="submit" class="w-full group relative flex justify-center items-center gap-2 bg-orange-500 hover:bg-orange-600 text-white font-bold py-4 rounded-xl transition-all shadow-[0_0_20px_rgba(249,115,22,0.3)] hover:shadow-[0_0_30px_rgba(249,115,22,0.5)] overflow-hidden">
                    <span class="relative z-10">Sign In</span>
                    <i data-feather="arrow-right" class="relative z-10 w-4 h-4 group-hover:translate-x-1 transition-transform"></i>
                </button>
            </form>

            <p class="text-center text-slate-400 mt-8">
                Don't have an account? <a href="register.jsp" class="text-orange-500 font-medium hover:text-orange-400 transition-colors">Create one now</a>
            </p>
        </div>
    </div>

    <!-- Right: Image -->
    <div class="hidden lg:block lg:w-1/2 relative">
        <div class="absolute inset-0 bg-slate-900/20 mix-blend-multiply z-10"></div>
        <div class="absolute inset-0 bg-gradient-to-r from-slate-950 via-transparent to-transparent z-10"></div>
        <img src="https://images.unsplash.com/photo-1514933651103-005eec06c04b?q=80&w=1934&auto=format&fit=crop" alt="Luxury Restaurant" class="absolute inset-0 w-full h-full object-cover">
    </div>

    <script>
        feather.replace();
    </script>
</body>
</html>

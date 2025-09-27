<script setup>
import { RouterLink, RouterView } from 'vue-router'
</script>

<template>
  <div class="min-h-screen bg-gray-50 flex flex-col">
    <!-- Navbar -->
    <header class="bg-white shadow">
      <div class="max-w-6xl mx-auto flex items-center justify-between p-4">
        <div class="flex items-center space-x-3">
          <img alt="Vue logo" class="w-12 h-12" src="@/assets/logo.svg" />
          <span class="text-xl font-bold text-gray-700">Library System</span>
        </div>
        <nav class="flex space-x-6 text-gray-600 font-medium">
          <RouterLink
            to="/"
            class="hover:text-blue-600 transition"
            active-class="text-blue-600 font-semibold"
          >
            Home
          </RouterLink>
          <RouterLink
            to="/books"
            class="hover:text-blue-600 transition"
            active-class="text-blue-600 font-semibold"
          >
            Books
          </RouterLink>
          <RouterLink
            to="/borrowers"
            class="hover:text-blue-600 transition"
            active-class="text-blue-600 font-semibold"
          >
            Borrowers
          </RouterLink>
          <RouterLink
            to="/loans"
            class="hover:text-blue-600 transition"
            active-class="text-blue-600 font-semibold"
          >
            Loans
          </RouterLink>
        </nav>
      </div>
    </header>

    <!-- Page Content -->
    <main class="flex-1 max-w-6xl mx-auto w-full p-6">
      <RouterView />
    </main>

    <!-- Footer -->
    <footer class="bg-gray-100 text-center text-sm text-gray-500 py-4">
      © 2025 Library Loan Management
    </footer>
  </div>
</template>
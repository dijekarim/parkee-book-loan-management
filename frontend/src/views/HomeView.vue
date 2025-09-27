<script setup lang="ts">
import { ref, onMounted } from "vue";
import api from "@/services/api";

interface Loan {
  id: number;
  borrower: { id: number; name: string };
  book: { id: number; title: string };
  borrow_date?: string;
  return_date: string;
  status?: string;
}

interface Stats {
  books: number;
  total_stock: number;
  borrowers: number;
  active_loans: number;
  overdue_loans: number;
  returned_loans: number;
  recent_loans: Loan[];
  overdue_loans_list: Loan[];
}

const stats = ref<Stats | null>(null);

const fetchStats = async () => {
  const res = await api.get("/dashboard");
  stats.value = res.data;
};

onMounted(fetchStats);
</script>

<template>
  <div>
    <h1 class="text-2xl font-bold text-gray-800 mb-6">📊 Dashboard</h1>

    <div v-if="!stats" class="text-gray-500">Loading stats...</div>

    <div v-else class="space-y-6">
      <!-- Top Stats -->
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
        <div class="bg-white p-6 shadow rounded-lg">
          <h2 class="text-lg font-semibold text-gray-700">📘 Books</h2>
          <p class="text-2xl font-bold mt-2">{{ stats.books }}</p>
          <p class="text-sm text-gray-500">Total Stock: {{ stats.total_stock }}</p>
        </div>

        <div class="bg-white p-6 shadow rounded-lg">
          <h2 class="text-lg font-semibold text-gray-700">👤 Borrowers</h2>
          <p class="text-2xl font-bold mt-2">{{ stats.borrowers }}</p>
        </div>

        <div class="bg-white p-6 shadow rounded-lg">
          <h2 class="text-lg font-semibold text-gray-700">📑 Active Loans</h2>
          <p class="text-2xl font-bold mt-2 text-green-600">{{ stats.active_loans }}</p>
        </div>

        <div class="bg-white p-6 shadow rounded-lg">
          <h2 class="text-lg font-semibold text-gray-700">⚠️ Overdue Loans</h2>
          <p class="text-2xl font-bold mt-2 text-red-600">{{ stats.overdue_loans }}</p>
        </div>

        <div class="bg-white p-6 shadow rounded-lg">
          <h2 class="text-lg font-semibold text-gray-700">✅ Returned Loans</h2>
          <p class="text-2xl font-bold mt-2 text-gray-800">{{ stats.returned_loans }}</p>
        </div>
      </div>

      <!-- Recent Loans Table -->
      <div class="bg-white shadow rounded-lg p-6">
        <h2 class="text-lg font-semibold text-gray-700 mb-4">📑 Recent Loans</h2>
        <table class="min-w-full divide-y divide-gray-200 text-sm">
          <thead>
            <tr class="text-left text-gray-500">
              <th class="px-3 py-2">Borrower</th>
              <th class="px-3 py-2">Book</th>
              <th class="px-3 py-2">Borrow Date</th>
              <th class="px-3 py-2">Return Date</th>
              <th class="px-3 py-2">Status</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-100">
            <tr v-for="loan in stats.recent_loans" :key="loan.id">
              <td class="px-3 py-2">{{ loan.borrower.name }}</td>
              <td class="px-3 py-2">{{ loan.book.title }}</td>
              <td class="px-3 py-2">{{ loan.borrow_date }}</td>
              <td class="px-3 py-2">{{ loan.return_date }}</td>
              <td class="px-3 py-2">
                <span
                  :class="{
                    'text-green-600 font-medium': loan.status === 'Returned',
                    'text-blue-600 font-medium': loan.status === 'Active',
                    'text-red-600 font-medium': loan.status === 'Overdue'
                  }"
                >
                  {{ loan.status }}
                </span>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- Overdue Loans List -->
      <div class="bg-white shadow rounded-lg p-6">
        <h2 class="text-lg font-semibold text-red-600 mb-4">⚠️ Overdue Loans</h2>
        <ul class="space-y-2">
          <li v-for="loan in stats.overdue_loans_list" :key="loan.id">
            {{ loan.borrower.name }} — <strong>{{ loan.book.title }}</strong>
            (due {{ loan.return_date }})
          </li>
        </ul>
      </div>
    </div>
  </div>
</template>
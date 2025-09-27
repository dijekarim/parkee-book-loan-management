<script setup lang="ts">
import { ref, onMounted } from "vue";
import api from "@/services/api";

interface Borrower {
  id: number;
  id_card_number: string;
  name: string;
  email: string;
}

interface Pagination {
  page: number;
  prev: number | null;
  next: number | null;
  last: number;
  count: number;
  from: number;
  to: number;
}

const borrowers = ref<Borrower[]>([]);
const pagination = ref<Pagination | null>(null);
const currentPage = ref(1);

const idCardNumber = ref("");
const name = ref("");
const email = ref("");

// 🔍 Search state
const search = ref("");

const fetchBorrowers = async (page = 1, query = "") => {
  const res = await api.get("/borrowers", {
    params: { page, q: query || undefined },
  });
  borrowers.value = res.data.data;
  pagination.value = res.data.pagination;
  currentPage.value = page;
};

const addBorrower = async () => {
  if (!idCardNumber.value || !name.value || !email.value) return;
  await api.post("/borrowers", {
    id_card_number: idCardNumber.value,
    name: name.value,
    email: email.value,
  });
  idCardNumber.value = "";
  name.value = "";
  email.value = "";
  fetchBorrowers(currentPage.value, search.value);
};

const handleSearch = () => {
  fetchBorrowers(1, search.value);
};

onMounted(() => fetchBorrowers(1));
</script>

<template>
  <div>
    <h1 class="text-2xl font-bold text-gray-800 mb-6">🧑 Borrowers</h1>

    <!-- 🔍 Search Bar -->
    <div class="flex gap-2 mb-6">
      <input
        v-model="search"
        @keyup.enter="handleSearch"
        type="text"
        placeholder="Search by ID, name, or email..."
        class="border rounded px-3 py-2 flex-1"
      />
      <button
        @click="handleSearch"
        class="bg-indigo-600 text-white px-4 py-2 rounded hover:bg-indigo-700"
      >
        Search
      </button>
    </div>

    <!-- Add Borrower Form -->
    <form @submit.prevent="addBorrower" class="flex flex-wrap gap-3 mb-8">
      <input v-model="idCardNumber" type="text" placeholder="ID Card Number"
        class="border rounded px-3 py-2 flex-1" />
      <input v-model="name" type="text" placeholder="Name"
        class="border rounded px-3 py-2 flex-1" />
      <input v-model="email" type="email" placeholder="Email"
        class="border rounded px-3 py-2 flex-1" />
      <button class="bg-green-600 text-white px-4 py-2 rounded hover:bg-green-700">
        Add
      </button>
    </form>

    <!-- Borrowers Table -->
    <div class="overflow-x-auto bg-white shadow rounded-lg">
      <table class="min-w-full text-sm text-left">
        <thead class="bg-gray-100 text-gray-700 uppercase text-xs">
          <tr>
            <th class="px-4 py-2">ID</th>
            <th class="px-4 py-2">ID Card</th>
            <th class="px-4 py-2">Name</th>
            <th class="px-4 py-2">Email</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="b in borrowers" :key="b.id" class="border-t hover:bg-gray-50">
            <td class="px-4 py-2">{{ b.id }}</td>
            <td class="px-4 py-2">{{ b.id_card_number }}</td>
            <td class="px-4 py-2">{{ b.name }}</td>
            <td class="px-4 py-2">{{ b.email }}</td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Pagination -->
    <div v-if="pagination" class="flex justify-between items-center mt-6">
      <button
        :disabled="!pagination.prev"
        @click="fetchBorrowers(pagination.prev || 1, search)"
        class="px-4 py-2 rounded bg-gray-200 text-gray-600 hover:bg-gray-300 disabled:opacity-50"
      >
        Previous
      </button>

      <span class="text-sm text-gray-600">
        Page {{ pagination.page }} of {{ pagination.last }}
        (showing {{ pagination.from }}–{{ pagination.to }} of {{ pagination.count }})
      </span>

      <button
        :disabled="!pagination.next"
        @click="fetchBorrowers(pagination.next || pagination.last, search)"
        class="px-4 py-2 rounded bg-gray-200 text-gray-600 hover:bg-gray-300 disabled:opacity-50"
      >
        Next
      </button>
    </div>
  </div>
</template>
import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'
import BooksView from '@/views/BooksView..vue'
import BorrowersView from '@/views/BorrowersView..vue'
import LoansView from '@/views/LoansView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomeView,
    },
    {
      path: '/books',
      name: 'books',
      component: BooksView,
    },
    {
      path: '/borrowers',
      name: 'borrowers',
      component: BorrowersView,
    },
    {
      path: '/loans',
      name: 'loans',
      component: LoansView,
    },
  ],
})

export default router

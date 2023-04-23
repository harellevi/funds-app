import { useEffect, useState } from 'react'
import { Route, Routes } from 'react-router-dom'
import Header from './components/Header'
import Home from './views/Home'
import Project from './views/Project'
import { isWallectConnected } from './services/blockchain'
import { ToastContainer } from 'react-toastify'

const App = () => {
  const [loaded, setLoaded] = useState(false)

  //כל פעם  שנרפרש את האתר הפונקציה תבדוק האם יש כבר ארנק שמחובר
  useEffect(async () => {
    await isWallectConnected()
    console.log('Blockchain loaded')
    setLoaded(true)
  }, [])

  return (
    <div className="min-h-screen relative">
      <Header />
      {/* רק אם הפרויקט נטען נוכל לעבור  */}
      {loaded ? (
        <Routes>
          {/* כאשר לוחצים על הלוגו נעבור לדף הבית */}
          <Route path="/" element={<Home />} />
          {/* כאשר נלחץ על אחד הפרויקטים בדף הבית ננותב לדף ייחודי של הפרוייקט */}
          <Route path="/projects/:id" element={<Project />} />
        </Routes>
      ) : null}

        
      <ToastContainer
        position="bottom-center"
        autoClose={5000}
        hideProgressBar={false}
        newestOnTop={false}
        closeOnClick
        rtl={false}
        pauseOnFocusLoss
        draggable
        pauseOnHover
        theme="dark"
      />
    </div>
  )
}

export default App
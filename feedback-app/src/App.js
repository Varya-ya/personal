import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import Header from './components/Header';
import FeedbackList from './components/FeedbackList';
import FeedbackStats from './components/FeedbackStats';
import FeedbackForm from './components/FeedbackForm';
import AboutIconLink from './components/AboutIconLink';
import AboutPage from './pages/AboutPage';
import { FeedbackProvider } from './context/FeedbackContext';

// General structure of the main page
function App() {
    
    return (
        <FeedbackProvider>
            <Router>
                <div className='container'>
                    <Routes>
                        <Route path='/' element={
                            <>
                                <Header />
                                <FeedbackForm />
                                <FeedbackStats />
                                <FeedbackList />
                                <AboutIconLink />
                            </>
                        }>
                        </Route>

                        <Route path='/about' element={<AboutPage />} />
                    </Routes>
                </div>
            </Router>
        </FeedbackProvider>
        )
};

export default App
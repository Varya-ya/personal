import Navbar from '../components/layout/Navbar';
import { Link } from 'react-router-dom';

function Home() {

    return (
        <div>
            <Navbar />

            <div className='flex-1 px-2 mx-2'>
                <div className='flex justify-end'>
                    <Link to='/about' className='btn btn-ghost btn-sm rounded-btn'>
                        About
                    </Link>
                </div>
            </div> 
            <h1 className='text-6xl'>Welcome</h1>
        </div>
     )
}

export default Home
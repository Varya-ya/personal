import Navbar from '../components/layout/Navbar';
import { Link } from 'react-router-dom';

function About() {

    return (

        <div>
            <Navbar />

            <div className='flex-1 px-2 mx-2'>
                <div className='flex justify-end'>
                    <Link to='/' className='btn btn-ghost btn-sm rounded-btn'>
                        Home
                    </Link>
                </div>
            </div>
                <h1 className='text-6xl mb-4'>Github Finder</h1>
                <p className='mb-4 text-2xl font-light'>
                    A React app to search GitHub profiles and see profile details.
                </p>
        </div>
    )
}

export default About
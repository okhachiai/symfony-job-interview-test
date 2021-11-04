<?php
namespace App\Controller;

use App\Entity\Uri;
use App\Repository\UriRepository;
use Doctrine\DBAL\Driver\Connection;
use Symfony\Component\HttpFoundation\RedirectResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;
use Symfony\Component\Routing\Annotation\Route;

class RedirectController
{
    /**
     * @Route("redirect", name="app_redirect_index", methods={"GET"})
     *
     * @param \Symfony\Component\HttpFoundation\Request $request
     * @param \App\Repository\UriRepository $uriRepository
     * @return \Symfony\Component\HttpFoundation\RedirectResponse
     * @throws \Doctrine\ORM\NonUniqueResultException
     */
    public function index(Request $request, UriRepository $uriRepository): RedirectResponse
    {
        $token = $request->query->get('token');
        $uri = $uriRepository->findOneByToken($token);
        if (!isset($uri)) {
            throw new NotFoundHttpException('The URI does not exist');
        }
        $uri->setTimesUsed($uri->getTimesUsed() + 1);
        $uriRepository->incrementTimesUsed($uri);
        return new RedirectResponse($uri->getUrl());
    }

    /*
    public function index(Connection $connection)
    {
        $token = $_GET['token'];

        $uri = $connection->fetchAll("SELECT * FROM uri where token = '$token'")[0];

        $connection->query("UPDATE uri SET times_used = times_used + 1 where token = '$token'");

        header('Location: ' . $uri['url']);
        exit;
    }
    */
}
